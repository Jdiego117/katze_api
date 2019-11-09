class Multimedium < ApplicationRecord
	self.inheritance_column = :foo
 	attr_accessor :type
end
