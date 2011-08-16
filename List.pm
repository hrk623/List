# 2011はてなインターン事前課題2(List.pm)
# Author: hrk623

use strict;
use warnings;

########################################################
# Nodeパッケージ
# - Nodeは連結リストの中の1つの要素を構成する構造体です。
# - Nodeは以下の2つのメンバーを保持します。
#   1. next: このNodeの次のNode
#   2. value: このNodeが保持する要素です。
package Node;

sub new{
		my $class = shift;
		my $self = { 
				next => undef, 
				value => shift 
		};
		return bless $self, $class;
}

# value関数
# - このNodeが持つ要素(value)を返すアクセッサー関数。
# pre: 
# post: return $self->{value}
sub value{
		my $self = shift;
		return $self->{value};
}

########################################################
# My::Listパッケージ
# - My::Listは複数のNodeからなる、連結リストです。
# - My::Listは以下の2つのメンバーを保持します。
#   1. head: このListの先頭のNode
#   2. tail: このListの後尾のNode
package My::List;

sub new {
		my $class = shift;
		my $self = { 
				head => undef, 
				tail => undef
		};
		return bless $self, $class;
}

# append関数
# - このListの最後に要素を追加します。
# pre: $self ≠ undef
# post: リストの後尾に要素を追加
sub append {
		my $self = shift;
		my $content = shift;
		
		# create new Node
		my $new_node = Node->new($content);

		# add the node
		if ( $self->{head}){
				$self->{tail}->{next} = $new_node;
				$self->{tail} = $new_node;
		}
		else{ 
				$self->{head} = $self->{tail} = $new_node;
		}
}

# イテレータ関数
# pre: $self ≠ undef
# post: $selfのイテレータを返す
sub iterator {
		my $self = shift;
		
		# create an iterator and return
		return  Iterator->new($self->{head}); 
}

########################################################
# Iteratorパッケージ
# - 
# - Iteratorは以下の1つのメンバーを保持します。
#   1. head: このListの先頭のNode
package Iterator;

sub new {
		my $class = shift;
		my $self = { head => &copy_node(shift) };
		return bless $self, $class;
}

# copy_node関数
# - コンストラクタのヘルパー関数。
# - 与えられたリストをディープにコピー
# - 再帰によるコピー
# pre: $head ∈ Node
# post: $headのコピーとそのnextは$headのnextのコピーを返す
sub copy_node{
		my $head = shift;
		unless( $head ){ return undef; }
    
		my $copied_node = Node->new($head->{ value });
		$copied_node->{next} = copy_node($head->{next});
		return $copied_node;
}

# has_next関数
# pre: 
# post: $self == øならfalse, それ以外ならtrueを返す
sub has_next{
		my $self = shift;
		return $self->{head};
}

# next関数
# pre: $self-> has_next == true
# post: 次の要素を返す
sub next{
		my $self = shift;
		my $node = $self->{head};
		$self->{head} = $node->{next};
		return $node;
}





package main;

# Test 1: 追加して、そのまま出力
my $lst = My::List->new;
$lst->append("Hello ");
$lst->append("World ");
$lst->append("I ");
$lst->append("am ");
$lst->append("awsome!");


my $ite = $lst->iterator;
print "Test 1:\n";
print "Expected: Hello World I am awsome!\n";
print "Result:   ";
while($ite->has_next){
		print $ite->next->value;
}
print "\n\n";


# Test 2:追加して、イテレータを取り出したあと、更に追加。
print "Test 2:\n";
$lst = My::List->new;
$lst->append("Hello ");
$lst->append("World ");
$ite = $lst->iterator;
$lst->append("I ");
$lst->append("am ");
$lst->append("awsome!");

print "Expected: Hello World\n";
print "Result:   ";
while($ite->has_next){
		print $ite->next->value;
}
print "\n\n";

