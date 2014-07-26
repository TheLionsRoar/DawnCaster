client/verb
	breakTile()
		var/icon/i = input("Please supply the file to break","Break Tile") as icon|null
		if(!i)
			return
		i = icon(i)
		if(i.Width()!=TEXTURE_WIDTH||i.Height()!=TEXTURE_HEIGHT)
			alert("The file supplied does not match the specified dimensions of [TEXTURE_WIDTH]x[TEXTURE_HEIGHT]","Unable to import","OK")
			return

		var/icon/j = icon()
		j.Crop(1,1,64,64)
		j.Insert(i,"")
		var/icon/k
		for(var/x=1;x<=TEXTURE_WIDTH;x++)
			k = new(i)
			k.Crop(x,1,x,TEXTURE_HEIGHT)
			k.Crop(1,1,64,64)
			j.Insert(k,"[x]")
		usr << ftp(j,"[i]")