prioritylist
	var
		list/values = list()
		len = 0
	proc
		//add one or more elements to the list
		Add()
			if(args.len % 2 != 0)
				CRASH("Add() requires an object and a priority value for every supplied entry.")
			var/count=1
			//add all elements to the value array
			while(count<=args.len)
				if(!.)
					. = __Add(args[count++],args[count++])
				else
					__Add(args[count++],args[count++])
			//update the len variable
			len = values.len

		//do not call. Internal function
		__Add(datum/d,priority)
			//don't do anything if d is already in the list
			if(d in values)
				return 0
			//if priority is less than the first element, add to beginning
			if(values.len)
				if(priority<=values[values[1]])
					values.Insert(1,d)
					values[d] = priority
					return 1
				//if the last element is less or equal to new priority, add to end
				if(priority>=values[values[values.len]])
					values.Add(d)
					values[d] = priority
					return 1
				//prepeare a search for the index by priority
				var/i = floor(values.len/2)
				var/vpos = i
				//divide and conquer algorithm
				while(i>1)
					//halve i
					i = floor(i/2)
					//check if left or right
					if(priority>=values[vpos])
						vpos += i
					else
						vpos -= i
				//after search has reached final index, insert the element
				values.Insert(vpos + 1,d)
				values[d] = priority
			else
				values.Add(d)
				values[d] = priority
			return 1

		//remove one or more elements from the list
		Remove()
			var/count=1
			while(count<=args.len)
				if(!.)
					. = values.Remove(args[count++])
				else
					values.Remove(args[count++])
			//update the len variable
			len = values.len

		//cut part of the list
		Cut(start,end)
			. = values.Cut(start,end)
			len = values.len

		//copy part of the list
		Copy(start,end,aspriority=0)
			//if aspriority is specified, we return a new prioritylist instead of a list segment.
			if(aspriority)
				. = new/prioritylist(values.Copy(start,end))
			else
				. = values.Copy(start,end)

		//swap two values by index
		Swap(index1,index2)
			values.Swap(index1,index2)

		//get the index of a
		Find(a)
			return values.Find(a)

	New(list/nlist=null)
		if(nlist)
			values = nlist
			len = values.len