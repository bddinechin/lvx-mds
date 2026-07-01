#!/bin/env ruby
# encoding: utf-8

# This file implements a jump-table generator for recursive decent parser with
# infinite look-ahead.  The jump-table is mostly the same as that of a
# traditional LL(1), except that ambiguities are kept, and the parsing driver
# have to backtrack to resolve them.
#
# Implementation notes:
#
# Example instructions:
#
# OPCODE1 ARG1 ARG2 ARG3 ARG4
# OPCODE1 ARG1 ARG2 ARG3 ARG5
# OPCODE2 ARG1 ARG2 ARG3
#
# A list of instructions are imported from the machine description system
# (EXTRACT_INSNS_FROM_MDS).  Those instructions are then factorized in 2 steps:

#   1. A compacted prefix tree is build in INSNS_TO_TREE.
#
#                                             ARG4
#             / OPCODE1 - ARG1 - ARG2 - ARG3 /
#            /                               \
#           .                                 ARG5
#            \
#             \ OPCODE2 - ARG1 - ARG2 - ARG3

#   2. The common chains of the compacted prefix tree are factorized in
#   FACTORIZE.
#
#     In the above tree, there one chain: [ARG1 - ARG2 - ARG3], which will be
#     factorized as [[ARG1-ARG2]-ARG3].
#
#     At this point, we have the following representation:
#
#       S -> OPCODE1 ARG12345
#       S -> OPCODE2 ARG123
#       ARG12345 -> ARG123 ARG45
#       ARG123 -> ARG12 ARG3
#       ARG12 -> ARG1 ARG2
#       ARG45 -> ARG4 | ARG5
#
#   3. Rules are generated, and all tokens are replaced by an unique index.
#
#       0 -> 1 11 | 2 8
#       11 -> 8 9
#       8 -> 10 5
#       9 -> 6 | 7
#       10 -> 3 4
#
#   4. The first and follow set are computed and the jump-table is generated.
#
#      OPCODE1 OPCODE2 ARG1  ARG2  ARG3 ARG4 ARG5
#   0  (1, 11) (2, 8)   -     -     -    -    -
#   1    OK      -      -     -     -    -    -
#   2    -       OK     -     -     -    -    -
#   3    -       -      OK    -     -    -    -
#   4    -       -      -     OK    -    -    -
#   5    -       -      -     -     OK   -    -
#   6    -       -      -     -     -    OK   -
#   7    -       -      -     -     -    -    OK
#   8    -       -     (10,5) -     -    -    -
#   9    -       -      -     -     -   (6, ) (7, )
#   10   -       -     (3, 4) -     -    -     -
#   11   -       -     (8, 9) -     -    -     -
#
#  Tuples are of the form (jump_target, stack_it). JUMP_TARGET is the rule to go
#  next, and STACK_IT is the rule to append to the stack.
#
# Example: Parsing of OPCODE1 ARG1 ARG2 ARG3 ARG4
#
# token OPCODE1, jump_target = 0, stack =
# token OPCODE1, jump_targe1 = 1, stack = 11
# token OPCODE1, MATCH
# token ARG1, jump_target = 11, stack =
# token ARG1, jump_target = 8, stack = 9
# token ARG1, jump_target = 10, stack = 5 9
# token ARG1, jump_target = 3, stack = 4 5 9
# token ARG1, MATCH
# token ARG2, jump_target = 4
# token ARG2, MATCH
# token ARG3, jump_target = 5
# token ARG3, MATCH
# token ARG4, jump_target = 9
# token ARG4, jump_target = 6
# token ARG4, MATCH
# FULL MATCH
#
# Types and Terminology
#
# Example grammar (1):
#   S -> ABD | BC
#   A -> a | ε
#   B -> b
#   C -> c
#   D -> d
#   where S, A, B, C, and D are productions; a, b, c, and d are terminals and ε
#   is the empty string and $ marks the of input.
#
# - FIRST set of a rule r (denoted ^(r)): The set of tokens which can start a
# rule.  The first set of the example grammar (1) is a follow:
#  ^(S) = { a, b } ; ^(A) = { a, ε } ; ^(B) = { b } ; ^(C) = { c } ; 
#  ^(D) = { d }
#  This is a hash which maps each rule (represented by an index) to a set of token.
#
# - FOLLOW set of a rule r (denoted >(r)): The set of tokens which can follow a
# rule. The follow sets of the example grammar (1) are:
#  >(S) = { $ } ; >(A) = { b } ; >(B) = { d } ; >(C) = { $ } ; >(D) = { $ }
#  This is a hash which maps each rule (represented by an index) to a set of token.
#
# - TOKEN: The representation of valid terminal of the grammar as a String.
#
# - INSTRUCTION: A list of token.
#
# - RULES: A hash of rules. The rules obtained in step 3. above are encoded as:
#     {
#       0: [[1, 11], [2, 8]]
#       11: [8, 9]
#       8: [10 5]
#       9: [[6], [7]]
#       10: [[3], [4]]
#      }
#

require 'MDS'
require 'rexml/document'

# Fixnum was used to represent native number in ruby
# This is an simple replacement.
# TODO: it is really unclear why we handle both Integer ranges diffrently.
#       We should investigate and findout if we really still need that
def fixnum?(num)
  return (num >= -(2**63)) && (num <= (2**63 - 1)) if num.is_a? Integer

  false
end

def read_mds(arch_descr_file)
  descr = File.read(arch_descr_file)
  Mds::MdsDescription.new(REXML::Document.new(descr).root)
end

def deep_replace(a, b, list)
  # Recursively replace A by B in LIST (a list of list).
  list.map do |l|
    if l.class == Array then
      deep_replace(a, b, l)
    else
      if l == a then b else l end
    end
  end
end


def overweight_seps(word)
  seps =  [ '=', ',', '[', ']', '?', '@', '(', ')' ]
  word.split('').map { |c| (seps.include? c) ? (c.ord + 150).chr : c }.join  
end

def insns_to_ptree insns
  # Construct a prefix tree out a list of instructions INSNS.

  def insert(insn, ptree)
    # Insert INSN (a list of token) into PTREE, by merging the longest common
    # prefix of INSN and PTREE.
    if !insn.empty? then
      hd, *tl = insn
      ptree[hd] = insert(tl, ptree[hd] || {})
    end
    return ptree
  end

  def simplify(ptree)
    # Compactify a prefix tree (represented as a Hash)
    # That is node with only one leaf are merged into their parent recursively.

    new_ptree = Hash.new
    ptree.each do |key, val|
      if val.keys.size == 1 then
        h = simplify(val)
        hk = h.keys[0]
        new_ptree[[key, hk].flatten] = h[hk]
      else
        new_ptree[[key]] = simplify(val)
      end
    end

    return new_ptree
  end

  ptree = Hash.new
  insns.each do |insn|
    ptree = insert(insn, ptree)
  end

  return simplify(ptree)
end


def factorize exprs, terminals
  # Factorize list of expressions (an expression expression is a list of tokens).
  # For example, the following list of expressions
  # @params: expr (type: list of expressions)
  #
  #   [
  #     [ ARG1, ARG2, ARG3 ],
  #     [ ARG1, ARG2, ARG3, ARG4 ],
  #   ]
  # when factorized (fexprs) will become,
  #   [
  #     ARG12, ARG3
  #     ARG12, ARG34
  #   ]
  # and the factor map will explain how expressions should be expanded to get
  # back to the original form, here the factor map is
  #   {
  #     ARG1: [ ARG1 ], ARG2: [ ARG2 ], ARG3: [ ARG3 ], ARG4: [ ARG3 ],
  #     ARG12: [ ARG1, ARG2 ], ARG34: [ ARG3, ARG4 ],
  #   }
  to_id = { }

  # Counters, this is a hash which counts how much time an expression appears in
  # the whole ptree.
  counters = Hash.new 0
  next_id = 1 # 0: Is reserved for the start symbol.

  insert_in_table = lambda do |val|
    # Insert VAL in an index table, if VAL is already stored in the index table
    # returns its index.  This is a way to cheaply implement detect similar
    # expression by value-numbering.
    if fixnum? val then val = [val] end
    if val.size == 1 and fixnum? val[0] then
      counters[val[0]] += 1
      val[0]
    else
      if !to_id.include? val then
        to_id[val] = next_id
        next_id += 1
      end
      counters[to_id[val]] += 1
      to_id[val]
    end
  end

  reset_counters = lambda do
    counters = Hash.new 0
  end

  compute_score = lambda do |l|
    # The more a sub-expression appear the best is its score.
    l.inject(0) { |acc,x| acc + counters[to_id[x]] }
  end

  select_best = lambda do |l|
    l[l.map { |x| compute_score.call(x) }.each_with_index.max[1]]
  end

  # 1. Extract all the single elements and replace them by numbers
  # terminal_list = exprs.flatten.sort_by { |w| overweight_seps(w) }.uniq.map { |val| insert_in_table.call(val) }
  terminal_list = terminals.map { |val| insert_in_table.call(val) }

  exprs = exprs.map { |list| list.map { |val| insert_in_table.call(val) } }
  counters = Hash.new 0
  reset_counters.call

  # Main factorize loop, loop until the factorization is stable and all rules
  # are of the form:
  # A -> K | B C | E F | ...
  # ie, a production can be expanded into at most two new productions.
  loop do
    new_exprs = exprs.map { |x| if x.size == 1 then [x] else [x.each_slice(2).to_a, [[x[0]]] + x[1..-1].each_slice(2).to_a] end }
    new_exprs.map! { |l| l.map { |ll| ll.map { |lll| insert_in_table.call(lll) } } }
    new_exprs.map! { |l| select_best.call(l) }
    reset_counters.call
    break if new_exprs.flatten.size == exprs.flatten.size
    exprs = new_exprs
  end

  # At this point, LLIST is a valid set of rules, but some of them were created
  # during the factorization, but since they did not lead to an optimal
  # factorization they are not used any more and are just bloat.

  def extract_really_used(list, hash)
    # Extract the index of the rules which are really used.
    if list.class != Array then return [list] end
    really_used = list
    list.each do |val|
      really_used += extract_really_used(hash[val], hash)
    end
    return really_used.uniq
  end

  # Create the pre-final hash without the useless rules
  rev_hash = {}
  to_id.each do |key, val|
    rev_hash[val] = key
  end

  factor_map = {}
  extract_really_used((exprs.flatten + terminal_list).flatten, rev_hash).each do |val|
    factor_map[val] = rev_hash[val] unless rev_hash[val].nil?
  end

  fexprs = []
  exprs.each do |val|
    id = insert_in_table.call(val)
    factor_map[id] = val if factor_map[id].nil?
    fexprs += [id]
  end

  return [fexprs, factor_map]
end

def print_tree(ptree, indent = 0)
  # Debug routine to print a prefix tree.
  ptree.each do |key, val|
    puts "#{"\t" * indent}#{key.join " "}"
    print_tree(val, indent + 1)
  end
end

def compute_rules(ptree, sub_rules, keymap)
  # @params: ptree
  #   A prefix tree representing all the instrutions.
  # @params: sub_rules
  #   A hash which explains how the sub-expressions have been factorized.
  # @params: keymap
  #   A hash which maps sub-expressions to their factorized forms.

  # We are going to piggy back on top of what did FACTORIZE, first get the last
  # id used by FACTORIZE in the global id table.
  next_id = sub_rules.keys.select { |x| fixnum? x }.max + 1

  table = { }
  insert_in_table = lambda do |val|
    if !table.include? val then
      table[val] = next_id
      next_id += 1
    end
    table[val]
  end

  acc = Hash.new []
  print_aux = lambda do |tree|
    tree.each do |key, val|
      prefix = table.include?(tree) ? table[tree] : 0
      next_rule = nil
      next_rule = insert_in_table.call(val) unless val.keys.empty?
      acc[prefix] += [[keymap[key], next_rule].compact]
      print_aux.call(val)
    end
  end

  print_aux.call(ptree)

  sub_rules.each do |k,v|
    acc[k] += [v] if !v.nil?
  end

  acc.each do |k,v|
    acc[k] = v.uniq
  end

  # Renumber the keys to have an index set without gaps.
  keys = acc.keys.sort
  keys.each.with_index do |key, idx|
    if idx != key then
      val_sav = acc[key]
      acc.delete key
      acc[idx] = val_sav
      acc.each do |k,v|
        acc[k] = deep_replace(key, idx, acc[k])
      end
    end
  end

  return acc
end

def compute_first_aux(nullable, rule, rules)
  # Compute the FIRST set of RULE
  #
  # @params: NULLABLE (type: list of integers)
  #   This list contains the index of the tokens that can be epsilon.
  # @params: RULE (type: int),
  #   The index of RULE in RULES.
  # @params: RULES

  alts = rules[rule]
  if alts[0].class == String then # terminal
    return nullable.include?(rule.to_i) ? [ rule, 'eps' ] : [ rule ]
  else
    firsts = []
    alts.each do |alt|
      fst_alt = []
      alt.each do |r|
        fst_alt = fst_alt.flatten.select { |x| x != 'eps' }
        fst_r = compute_first_aux(nullable, r, rules).flatten
        fst_alt << fst_r
        break unless fst_r.include?('eps')
      end
      firsts << fst_alt
    end
    return firsts
  end
end

def compute_firsts(nullable, rules)
  # Compute the FIRST set of each rule in RULES.
  # @params: NULLABLE (type: list of integers)
  #   This list contains the index of the tokens that can be epsilon.
  # @params: RULES
  #   Hash table with all the rules.

  firsts = {}
  rules.each do |hd, _|
    firsts[hd] = compute_first_aux(nullable, hd, rules).flatten.uniq
  end
  return firsts
end

def compute_follows(rules, firsts)
  # Compute the FOLLOW set for all rules in RULES.
  # @params: FIRSTS (type: hash, list of token that can begin a rule)
  #   This list contains the index of the tokens that can be epsilon.
  # @params: RULES
  #   Hash table with all the rules.

  follows = {}
  follows[0] = [ -3 ] # -3 means $ (the end of input)
  rules.each do |rule, alts|
    follows[rule] = [] if follows[rule].nil?
    alts.each do |alt|
      next if alt.class == String && rule == alt.to_i
      nb_alt = alt.size
      nb_alt.times do |i|
        follows[alt[i]] = [] if follows[alt[i]].nil?
        if i == nb_alt - 1 then
          follows[alt[i]] << follows[rule]
        else
          follows[alt[i]] << firsts[alt[i+1]].select { |x| x != 'eps' }
          if firsts[alt[i+1]].include?('eps') then
            follows[alt[i]] << follows[alt[i+1]]
          end
        end
      end
    end
  end

  return Hash[follows.map { |k, v| [k, v.flatten.uniq] }]
end

def compute_rules_from_insns(insns, terminals)
  # Compute a factorized grammar which can recognize INSNS.
  # @params insns (a list of instructions)

  def extract_sub_exprs ptree
    exprs = ptree.keys
    ptree.each do |key, val|
      exprs += extract_sub_exprs(val)
    end
    return exprs.sort.uniq
  end

  ptree = insns_to_ptree(insns)
  sexprs = extract_sub_exprs(ptree)
#  print_tree(ptree)
  idx_table, sub_rules = factorize(sexprs, terminals)
  expr_map = Hash[sexprs.zip(idx_table)]
  return compute_rules(ptree, sub_rules, expr_map)
end

def compute_parse_table(nullable, rules)
  # @params: NULLABLE
  #   The set of nullable rules
  # @params: RULE
  #   The set of rules

  firsts = compute_firsts(nullable, rules)
  follows = compute_follows(rules, firsts)

  parse_table = Hash.new
  rules.each do |id, alts|
    parse_table[id] = Hash.new([]) if parse_table[id].nil?
    alts.each do |alt|
      if alt.class == Array then
        firsts[alt[0]].each do |fst|
          if fst == 'eps' then
            follows[alt[0]].each do |follow|
              parse_table[id][follow] += [alt]
            end
          else
            parse_table[id][fst] += [alt]
          end
        end
      else
        alt = alt.to_i
        firsts[alt].each do |fst|
          if fst == 'eps' then
            follows[alt].each do |follow|
              parse_table[id][follow.to_i] += [[-2, -2]] if follow.to_i != alt
            end
          else
            parse_table[id][alt] = []
          end
        end
      end
    end
  end
  return parse_table
end

$header_common = <<-EOT
/* lvx-parse.h -- Recursive decent parser tables for the LVX ISA

   Copyright (C) 2009-2024 Free Software Foundation, Inc.
   Contributed by Kalray SA.

   This file is part of GAS.

   GAS is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the license, or
   (at your option) any later version.

   GAS is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING3. If not,
   see <http://www.gnu.org/licenses/>.  */

#ifndef __H_LVX_PARSER__
#define __H_LVX_PARSER__

struct token_list* parse (struct token_s tok);
void free_token_list (struct token_list* tok_list);
void setup (int version);
void cleanup (void);

\f

  EOT

def gen_c_structs(arch, parse_table, terminals, maps)
  # @param: arch, the processor architecture
  # @param: parse_table
  # @param: terminals, The list of terminals of the grammar
  # @maps: A list of useful maps concerning terminal symbols.

  tr_map = { "[" => 'rsbracket', "]" => 'lsbracket',
             "(" => 'rbracket', ")" => 'lbracket',
             "?" => 'qmark', "." => 'dot',
             "," => 'comma', "@" => 'abase',
             "=" => 'equal', "@splat32" => 'abase_splat32' }


  puts "/* #{arch.upcase} BEGIN {{{ */\n"
  if false
    puts "enum lvx_tokens_#{arch} {"
    terminals.each.with_index do |cat, k|
      if cat =~ /^[a-z]/ then
        puts "  Instruction_#{arch}_#{cat.gsub(/\./, '_').gsub(/@/, 'abase')} = #{k + 1},"
      elsif cat =~ /^[\(\)\[\]\?\.\=\,\@]/ then
        puts "  Separator_#{arch}_#{tr_map[cat]} = #{k + 1},"
      else
        puts "  #{cat} = #{k + 1},"
      end
    end
    puts "};\n\n"
  end

  puts "static const char *tokens_names_#{arch}[] = {"
  terminals.map { |x| if !(x =~ /^[\[\]\?\.\=\,\@]/).nil? then tr_map[x] else x end }.each_slice(3) do |val|
    puts "  #{val.map { |x| "\"#{x}\"" }.join ", "},"
  end
  puts "};"

  puts "\n\f\n"

  terminals.each do |val|
    if !(val =~ /^[\(\)\[\]\?\.\=\,\@]/).nil? then
      puts "static const char *sep_#{arch}_#{tr_map[val]}[] = { \"#{val}\" };\n"
    elsif !(val =~ /^[a-z]/).nil?
      puts "static const char *insn_#{arch}_#{val.gsub(/\./, '_').gsub(/@/, 'abase')}[] = { \"#{val}\" };\n"
    end
  end

  puts ""
  puts "#define _enc(x) (1ULL << ((x) - #{maps[:reg][0][0]}))"
  puts "enum prc_#{arch}_id_t {"
  maps[:pseudo_reg].each.with_index do |(cl, v), i|
    print "  prc_#{arch}_id_#{"%02d" % i} = "
    puts "#{cl.map { |x| "_enc (#{x})"}.join "\n   | "},"
  end
  puts "};\n"
  puts "#undef _enc"

  maps[:pseudo_reg].each.with_index do |(key, vals), i|
      puts ""
      puts "static const char *prc_#{arch}_#{"%02d" % i}[] = {"
      vals.each_slice(4).each do |slc|
        puts "  #{slc.map { |x| "\"#{x}\"" }.join ", "},"
      end
      puts "};\n"
  end

  puts "\f\n"

  puts "#define _enc(x) (1ULL << ((x) - #{maps[:mod][0][0]}))"
  puts "enum pmd_#{arch}_id_t {"
  maps[:pseudo_mod].each.with_index do |(cl, v), i|
    print "  pmd_#{arch}_id_#{"%02d" % i} = "
    puts "#{cl.map { |x| "_enc (#{x})"}.join "\n   | "},"
  end
  puts "};\n"
  puts "#undef _enc"

  maps[:pseudo_mod].each.with_index do |(key, vals), i|
    puts ""
    puts "static const char *pmd_#{arch}_#{"%02d" % i}[] = {"
    vals.each_slice(4).each do |slc|
      puts "  #{slc.map { |x| "\"#{x}\"" }.join ", "},"
    end
    puts "};\n"
  end

  puts "\f\n"

  puts "#define arr_len(arr) sizeof(arr)/(sizeof(*arr))"

  puts "static struct token_class reg_classes_#{arch}[] = {"
  maps[:pseudo_reg].each.with_index do |(key, vals), i|
    tmp = "prc_#{arch}_#{"%02d" % i}"
    puts "  { #{tmp}, prc_#{arch}_id_#{"%02d" % i}, arr_len (#{tmp}) },"
  end
  puts "  { NULL, -1, -1 },"
  puts "};\n\n"

  puts "static struct token_class mod_classes_#{arch}[] = {"
  maps[:pseudo_mod].each.with_index do |(key, vals), i|
    tmp = "pmd_#{arch}_#{"%02d" % i}"
    puts "  { #{tmp}, pmd_#{arch}_id_#{"%02d" % i}, arr_len (#{tmp}) },"
  end
  puts "  { NULL, -1, -1 },"
  puts "};\n\n"

#  puts "static struct token_class rmod_classes_#{arch}[] = {"
#  maps[:mod].each do |(key, vals)|
#    tmp = key.gsub(/Modifier/, "mod")
#    puts "  { #{tmp}, #{key}, arr_len (#{tmp}) },"
#  end
#  puts "  { NULL, -1, -1 },"
#  puts "};\n\n"

  puts "static struct token_class imm_classes_#{arch}[] = {"
  maps[:imm].each do |key, val|
    puts "  { NULL, #{key}, #{key =~ /_signed/ ? "-" : ""}#{val} },"
  end
  puts "  { NULL, -1, -1 },"
  puts "};\n\n"

  puts "static struct token_class insn_classes_#{arch}[] = {"
  terminals.each do |val|
    next if (val =~ /^[a-z]/).nil?
    tmp0 = "insn_#{arch}_#{val.gsub(/\./,'_').gsub(/@/, 'abase')}"
    tmp1 = "Instruction_#{arch}_#{val.gsub(/\./, '_').gsub(/@/, 'abase')}"
    puts "  { #{tmp0}, #{tmp1}, arr_len (#{tmp0}) },"
  end
  puts "  { NULL, -1, -1 }"
  puts "};\n\n"

  puts "static struct token_class sep_classes_#{arch}[] = {"
  terminals.each do |val|
    next if (val =~ /^[\(\)\[\]\?\.\=\,\@]/).nil?
    tmp0 = "sep_#{arch}_#{tr_map[val]}"
    tmp1 = "Separator_#{arch}_#{tr_map[val]}"
    puts "  { #{tmp0}, #{tmp1}, arr_len (#{tmp0}) },"
  end
  puts "  { NULL, -1, -1 }"
  puts "};\n\n"

  puts "\n\f\n"

  puts <<-EOT
struct token_classes token_classes_#{arch} = {
  .reg_classes  = reg_classes_#{arch},
  .mod_classes  = mod_classes_#{arch},
  .imm_classes  = imm_classes_#{arch},
  .insn_classes = insn_classes_#{arch},
  .sep_classes  = sep_classes_#{arch},
};

\f
  EOT

  parse_table.to_a.sort_by { |x| x[0].to_i }.each do |k,v|
    puts "static struct steering_rule rule_#{arch}_#{"%04d" % k}[] = {"
    v.sort_by { |x| x[0].to_i }.each do |steering, directions|
      steering = steering[0].to_i if steering.class == Array
      if directions.empty? then
          puts "  { .steering = #{"%4d" % steering}, .jump_target = #{"%4d" % -1 }, .stack_it = #{"%4d" % -1} },"
      else
        directions.each do |jump_target, stack_it|
          puts "  { .steering = #{"%4d" % steering}, .jump_target = #{"%4d" % (jump_target || -1)}, .stack_it = #{"%4d" % (stack_it || -1)} },"
        end
      end
    end
    puts "  { .steering = #{"%4d" % -1}, .jump_target = #{"%4d" % -1}, .stack_it = #{"%4d" % -1} },"
    puts "};\n\n"
  end

  puts "static struct rule rules_#{arch}[] = {"
  parse_table.map { |x| x[0] }.sort.each_slice(5) do |k|
    puts "  #{k.map { |x| "{ rule_#{arch}_#{"%04d }" % x}" }.join ", "},"
  end
  puts "};\n\n"

  imm_promote_map = Hash[[maps[:imm].inject([[],[]]) { |acc,(x,y)| acc = [acc[0] + [x], acc[1] + [y]] }[0]]
    .map { |x| x[0..-1].zip [x[1..-1],x[-1]].flatten }[0]]
  puts <<-EOT
static inline /* enum lvx_tokens_#{arch} */ int
promote_immediate_#{arch} (/* enum lvx_tokens_#{arch} */ int tok)
{
  switch (tok)
    {
EOT
  imm_promote_map.each do |v1, v2|
    if v1 != v2 then
      puts "      case #{v1}:\n	return #{v2};"
    end
  end
  puts <<-EOT
      default:
	return tok;
    }
}

EOT

puts <<-EOT
__attribute__((unused))
static void
setup_#{arch} (void)
{
  env.tokens_names      = tokens_names_#{arch};
  env.fst_reg           = #{maps[:reg][0][0]};
  env.sys_reg           = RegClass_#{arch}_systemReg;
  env.fst_mod           = #{maps[:mod][0][0]};
  env.promote_immediate = promote_immediate_#{arch};
  env.rules             = rules_#{arch};
  env.token_classes     = &token_classes_#{arch};
  env.insns             = NULL;
//  env.allow_all_sfr     = allow_all_sfr;
}

/* }}} #{arch.upcase} END */
EOT
end

def extract_insns_from_mds(target_mds)
  # Extract instructions from the Machine Document System
  #
  # @params: target_mds (type: MdsDescription), the Machine Document System to
  # read from
  #
  # This function returns a list of instructions in the following format where
  # each instruction is a list of tokens.
  # [
  #   [ tok1, tok2, tok3 ],
  #   [ tok1', tok2'],
  #   ...
  # ]
  # where tok1, tok2, etc. are Strings.

  insns = []

  target_mds.instructions.each do |_, insn|
    next if !insn.synthetic.empty?
    insn.formats.each do |fmt|
      ops = [insn.mnemonic] + fmt.operands.map { |ops| ops.method.id }
      stx = fmt.syntax
      suffix = !stx.match(/\..[^ ]*/).nil? ? stx.match(/\..[^ ]*/)[0] : ""
      stx = stx.gsub(/\..[^ ]*/, '')
      syntax = stx.split(/([% \?,()\[\]])/).map do |tok|
        if tok =~ /^\d+/ then ops[tok.to_i] else tok end
      end
      syntax[0] += suffix
      insns << syntax.select {|s| !(s =~ /[% ]/ || s.empty?)}.map { |s| s.gsub(/-/, '_') }
    end
  end

  target_mds.synthetics.each do |_, insn|
    insn.formats.each do |fmt|
      ops = [insn.mnemonic] + fmt.operands.map { |ops| ops.method.id }
      # Here we use insn.syntax because synthetics are specialized versions of
      # general instructions.
      stx = insn.forced.nil? ? fmt.syntax : insn.syntax
      suffix = !stx.match(/\..[^ ]*/).nil? ? stx.match(/\..[^ ]*/)[0] : ""
      stx = stx.gsub(/\..[^ ]*/, '')
      syntax = stx.split(/([% \?,()\[\]])/).map do |tok|
        if tok =~ /\d+/ then ops[tok.to_i] else tok end
      end
      syntax[0] += suffix
      insns << syntax.select {|s| !(s =~ /[% ]/ || s.empty?)}.map { |s| s.gsub(/-/, '_') }
    end
  end

  return insns
end

def compute_pseudo_class(klass)
  # Construct a set of non-overlapping klasses from a set of overlapping
  # klasses.
  #
  # @params: klass (type: Hash where each key stores a list),
  #   A set of overlapping klasses.

  # Currently a register (or modifier) can belong to many register (or modifier)
  # classes.  This is very inconvenient during lexing because each token should
  # have exactly one category.  This is the purpose of pseudo classes.  Each
  # register/modifier has at most one pseudo_{reg, mod}_class.

  # 1. Map Registers to RegClasses
  # From a initial hash of the form,
  #             [ RegClass => [ Registers of the RegClass ].
  # we build the reverse hash of the form
  #             [ Register => [ RegClasses to which Register belongs ].
  # where the set [ RegClasses to which Register belongs ] is the pseudo
  # register class of Register.
  reverse_klass = Hash.new []
  klass.each do |k, vals|
    vals.each do |v|
      reverse_klass[v] += [k]
    end
  end

  # 2. Assign Registers to the Pseudo-RegClasses.
  pseudo_klass = Hash.new []
  reverse_klass.each do |k, v|
    pseudo_klass[v] += [k]
  end

  return pseudo_klass
end

def gen_maps(target_mds, terminals)
  # Fill in the many mappings that will be needed during the generation of the
  # C header.
  #
  # @params: target_mds (type: MdsDescription),
  #   The Machine Description System to read from.
  # @params: terminals (type: String list),
  #   A list of terminals where all `-` have been sanitized to `_`.

  maps = {}

  # Map between RegClasses and RegNames
  maps[:reg] = target_mds.regclasses
    .map { |key, vals| [key.gsub(/[-\.]/, '_'),
                        vals.registers.map { |reg| target_mds.registers[reg].names }.flatten] }
    .select { |key, vals| true || terminals.include?(key) }
    .select { |key, vals| not (key =~ /_[0-9]+$/) }
    .sort

  # Map between Immediates and their sizes
  # This map SHOULD ALWAYS have the immediate sorted by their size from smaller
  # to bigger, and in case of conflict the Immediate which comes before in the
  # lexicographic order wins.
  maps[:imm] = target_mds.immediates
    .map { |key, val| [key.gsub(/[-\.]/, '_'), val.width] }
    .select { |key, vals| true || terminals.include?(key) }
    .sort_by {
      # Wrapped immediates should be tried only after all immediates which fits
      # on 2 syllables have been tried.
      |key, val| if key =~ /wrapped32/ then 48 elsif key =~ /wrapped8/ then 32 else val end }

  # Map between Modifier classes and their elements.
  maps[:mod] = target_mds.modifiers
    .map { |key, vals| [key.gsub(/[-\.]/, '_'), vals.members.map(&:downcase)] }
    .select { |key, vals| true || terminals.include?(key) }
    .sort

  # This is a list of all optional modifiers.
  # Modifiers are stored via their index in the TERMINAL array.
  # The `+ 1` is to account that the index are 1-based.
  maps[:nullable] = maps[:mod]
    .select { |_, vals| vals.include? '.' }
    .map { |key, _| terminals.index(key) }
    .compact
    .map { |n| n + 1 }

  maps[:pseudo_reg] = compute_pseudo_class(maps[:reg])
  maps[:pseudo_mod] = compute_pseudo_class(maps[:mod])

  return maps
end

def gen_header(target_mds, arch)
  # @param: target_mds (type: MdsDescription),
  #   The Machine Description System to read from.
  # @param: arch
  #   The processor architecture.

  insns = extract_insns_from_mds(target_mds)
  terminals = insns.flatten.sort_by { |w| overweight_seps(w) }.uniq
  maps = gen_maps(target_mds, terminals)

  terminals = terminals + maps[:reg].map { |a| a[0] } + maps[:mod].map { |a| a[0] } + maps[:imm].map { |a| a[0] }
  terminals = terminals.flatten.sort_by { |w| overweight_seps(w) }.uniq
  maps[:nullable] = maps[:mod]
    .select { |_, vals| vals.include? '.' }
    .map { |key, _| terminals.index(key) + 1 }

  # Remove from the rules all the terminals
  # This effectively promotes leaf (numbered rules to terminals)
  rules = Hash[compute_rules_from_insns(insns, terminals)
    .map { |hd, tl| tl[0].class == String ? [hd, ["#{hd}"]] : [hd, tl] }]

  parse_table = compute_parse_table(maps[:nullable], rules)
  gen_c_structs(arch, parse_table, terminals, maps)
end

def main
  cores = ENV["CORES"].split(' ')

  puts $header_common
  cores.each.with_index do |arch, i|
    target_mds = read_mds(ARGV[i])

    gen_header(target_mds, arch)
  end
  puts "#endif /* __H_LVX_PARSER__ */"
end

main()
