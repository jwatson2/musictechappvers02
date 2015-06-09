inlet = 1

var voice_count = 0;

function msg_int(i)
{
	voice_count = i;
	messnamed("poly_in1", "voices", i);
	post(voice_count, "voices\n");
}

function bang()
{
	var count = 1;
	while (count <= voice_count)
	{
		selector_num = parseInt(Math.random()*4)+1;
 		freq_offset = parseInt((Math.random()*100)+1)/1000;

		messnamed("poly_in1", "target", count);
		messnamed("poly_in4", "selector_num", selector_num);
		messnamed("poly_in4", "freq_offset", freq_offset);
		
		post(count, "\n", selector_num, freq_offset, "\n");
		count += 1;
	}
}