
# line 1 "simple_state_machine.rl"

# line 5 "simple_state_machine.rl"


  
# line 9 "simple_state_machine.rb"
class << self
	attr_accessor :_hello_trans_keys
	private :_hello_trans_keys, :_hello_trans_keys=
end
self._hello_trans_keys = [
	0, 0, 104, 104, 0, 0, 
	0
]

class << self
	attr_accessor :_hello_key_spans
	private :_hello_key_spans, :_hello_key_spans=
end
self._hello_key_spans = [
	0, 1, 0
]

class << self
	attr_accessor :_hello_index_offsets
	private :_hello_index_offsets, :_hello_index_offsets=
end
self._hello_index_offsets = [
	0, 0, 2
]

class << self
	attr_accessor :_hello_indicies
	private :_hello_indicies, :_hello_indicies=
end
self._hello_indicies = [
	0, 1, 1, 0
]

class << self
	attr_accessor :_hello_trans_targs
	private :_hello_trans_targs, :_hello_trans_targs=
end
self._hello_trans_targs = [
	2, 0
]

class << self
	attr_accessor :_hello_trans_actions
	private :_hello_trans_actions, :_hello_trans_actions=
end
self._hello_trans_actions = [
	1, 0
]

class << self
	attr_accessor :hello_start
end
self.hello_start = 1;
class << self
	attr_accessor :hello_first_final
end
self.hello_first_final = 2;
class << self
	attr_accessor :hello_error
end
self.hello_error = 0;

class << self
	attr_accessor :hello_en_main
end
self.hello_en_main = 1;


# line 8 "simple_state_machine.rl"

def run_machine(data)
  data = data.unpack("c*") if data.is_a?(String)
  puts "Running the state machine with input #{data}..."
  
  
# line 85 "simple_state_machine.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = hello_start
end

# line 14 "simple_state_machine.rl"
  
# line 94 "simple_state_machine.rb"
begin
	testEof = false
	_slen, _trans, _keys, _inds, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = cs << 1
	_inds = _hello_index_offsets[cs]
	_slen = _hello_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_hello_trans_keys[_keys] <= data[p] && 
			data[p] <= _hello_trans_keys[_keys + 1] 
		    ) then
			_hello_indicies[ _inds + data[p] - _hello_trans_keys[_keys] ] 
		 else 
			_hello_indicies[ _inds + _slen ]
		 end
	cs = _hello_trans_targs[_trans]
	if _hello_trans_actions[_trans] != 0
	case _hello_trans_actions[_trans]
	when 1 then
# line 4 "simple_state_machine.rl"
		begin
 puts "hello world!" 		end
# line 134 "simple_state_machine.rb"
	end
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	end
	if _goto_level <= _out
		break
	end
end
	end

# line 15 "simple_state_machine.rl"
  
  puts "Finished. The state of the machine is: #{cs}"
  puts "p: #{p} pe: #{pe}"
end

run_machine "hhh"
run_machine "hxh"