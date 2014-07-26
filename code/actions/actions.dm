var
	list/actions = list("idle"=new/action/idle,"walk"=new/action/walk)

action
	var
		id
	proc
		//whether this action permits yielding to new action
		CanAct(mob/actor/actor,action/new_action,list/params=null)
			return 1

		//allows this action to contradict another's CanAct()
		CanForce(mob/actor/actor,list/params=null)
			return 0

		//called when this action is forcibly ended
		Yield(mob/actor/actor,action/new_action,list/params=null)
			if(actor.client)
				actor.client.RemoveKeyListener(INPUT_DPAD,src)
				actor.client.RemoveKeyListener(INPUT_ANALOG,src)

		Begin(mob/actor/actor,list/params=null)
			actor.action = src
			actor.action_start = world.time
			if(actor.client)
				actor.client.AddKeyListener(INPUT_DPAD,src,0)
				actor.client.AddKeyListener(INPUT_ANALOG,src,0)

				if(actor.client.move_dir)
					onKeyPressed(actor.client.key_events[INPUT_DPAD])

		onKeyPressed(movekeyevent/e)

		onKeyReleased(movekeyevent/e)


	New(id=null)
		if(id)
			src.id = id

mob
	actor
		var
			tmp
				control = null
				action_start
				action/action
		proc
			//call to change the current action
			Act(action/new_action,list/params=null,force=0,blocking=1)
				//blocking call will wait until the action is finished to continue execution of parent function call, nonblocking won't.
				if(blocking)
					//if we can't get the action started, bail out
					if(!force && !action.CanAct(src,new_action,params) && !new_action.CanForce(src,params))
						return 0
					//tell the current action to stop
					action.Yield(src,new_action,params)
					//tell the new action to begin
					new_action.Begin(src,params)
					return 1
				else
					__ActNonBlocking(new_action=new_action,params=params,force=force)

			//do not call. This is called by a non-blocking Act() call.
			__ActNonBlocking(action/new_action,list/params=null,force=0)
				set waitfor = 0
				//if we can't get the action started, bail out
				if(!force && !action.CanAct(src,new_action,params) && !new_action.CanForce(src,params))
					return
				//tell the current action to stop
				action.Yield(src,new_action,params)
				//tell the new action to begin
				new_action.Begin(src,params)

			Idle()
				//forcibly idle
				Act(actions["idle"],null,1,0)

		Login()
			. = ..()
			src.action.Begin(src)

		New(loc)
			control = src
			src.action_start = world.time
			src.action = actions["idle"]
			..(loc)