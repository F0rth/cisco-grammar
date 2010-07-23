
#line 1 "simple_state_machine.rl"

#line 5 "simple_state_machine.rl"


  
#line 9 "simple_state_machine.c"
static const char _hello_actions[] = {
	0, 1, 0
};

static const char _hello_key_offsets[] = {
	0, 0, 1
};

static const char _hello_trans_keys[] = {
	104, 0
};

static const char _hello_single_lengths[] = {
	0, 1, 0
};

static const char _hello_range_lengths[] = {
	0, 0, 0
};

static const char _hello_index_offsets[] = {
	0, 0, 2
};

static const char _hello_trans_targs[] = {
	2, 0, 0, 0
};

static const char _hello_trans_actions[] = {
	1, 0, 0, 0
};

static const int hello_start = 1;
static const int hello_first_final = 2;
static const int hello_error = 0;

static const int hello_en_main = 1;


#line 8 "simple_state_machine.rl"

def run_machine(data)
  data = data.unpack("c*") if data.is_a?(String)
  puts "Running the state machine with input #{data}..."
  
  
#line 56 "simple_state_machine.c"
	{
	cs = hello_start;
	}

#line 14 "simple_state_machine.rl"
  
#line 63 "simple_state_machine.c"
	{
	int _klen;
	unsigned int _trans;
	const char *_acts;
	unsigned int _nacts;
	const char *_keys;

	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	_keys = _hello_trans_keys + _hello_key_offsets[cs];
	_trans = _hello_index_offsets[cs];

	_klen = _hello_single_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + _klen - 1;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( (*p) < *_mid )
				_upper = _mid - 1;
			else if ( (*p) > *_mid )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				goto _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _hello_range_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + (_klen<<1) - 2;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( (*p) < _mid[0] )
				_upper = _mid - 2;
			else if ( (*p) > _mid[1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				goto _match;
			}
		}
		_trans += _klen;
	}

_match:
	cs = _hello_trans_targs[_trans];

	if ( _hello_trans_actions[_trans] == 0 )
		goto _again;

	_acts = _hello_actions + _hello_trans_actions[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 0:
#line 4 "simple_state_machine.rl"
	{ puts "hello world!" }
	break;
#line 140 "simple_state_machine.c"
		}
	}

_again:
	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	_out: {}
	}

#line 15 "simple_state_machine.rl"
  
  puts "Finished. The state of the machine is: #{cs}"
  puts "p: #{p} pe: #{pe}"
end

run_machine "hhh"
run_machine "hxh"