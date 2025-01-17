/obj/item/shield/trayshield
	name = "tray shield"
	desc = "A makeshift shield that won't last for long."
	icon = 'code/shitcode/valtos/icons/weapons.dmi'
	lefthand_file = 'code/shitcode/valtos/icons/lefthand.dmi'
	righthand_file = 'code/shitcode/valtos/icons/righthand.dmi'
	icon_state = "trayshield"
	force = 5
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	materials = list(MAT_METAL=1000)
	attack_verb = list("shoved", "bashed")
	block_chance = 45
	armor = list("melee" = 50, "bullet" = 40, "laser" = 30, "energy" = 10, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	var/damage_received = 0 //Amount of damage the shield has received
	var/max_damage = 60 //Amount of max damage the trayshield can withstand

/obj/item/shield/trayshield/examine(mob/user)
	..()
	var/a = max(0, max_damage - damage_received)
	if(a <= max_damage/4) //20
		to_chat(user, "It's falling apart.")
	else if(a <= max_damage/2) //40
		to_chat(user, "It's badly damaged.")
	else if(a < max_damage)
		to_chat(user, "It's slightly damaged.")

/obj/item/shield/trayshield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 4, attack_type = MELEE_ATTACK)
	if(..())
		if(damage < 4)
			damage = 4
		if(istype(hitby, /obj/item/projectile))
			var/obj/item/projectile/P
			if(P.nodamage || !damage)
				damage = 0
		damage_received += damage
		if(damage_received >= max_damage)
			if(ishuman(owner))
				var/mob/living/carbon/human/H = owner
				H.visible_message("<span class='danger'>[H]'s [src] breaks!</span>", "<span class='userdanger'>Your [src] breaks!</span>")
				playsound(H, 'sound/effects/bang.ogg', 30, 1)
				H.dropItemToGround(src, 1)
				qdel(src)
		else
			var/sound/hitsound = list('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg')
			playsound(loc, pick(hitsound), 50, 1)
		return TRUE
	return FALSE

/obj/item/storage/bag/tray/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/ducttape))
		return
	..()

/obj/item/melee/shank
	name = "shank"
	desc = "A nasty looking shard of glass. There's duct tape over one of the ends."
	icon = 'code/shitcode/valtos/icons/weapons.dmi'
	icon_state = "shank"
	force = 10 //Average force
	throwforce = 10
	throw_speed = 4
	w_class = WEIGHT_CLASS_TINY
	item_state = "shard-glass"
	attack_verb = list("stabbed", "shanked", "sliced", "cut")
	siemens_coefficient = 0 //Means it's insulated
	embedding = list("embed_chance" = 10)
	sharpness = IS_SHARP

/obj/item/shard/shank/attack_self(mob/user)
	playsound(user, 'code/shitcode/valtos/sounds/ducttape2.ogg', 50, 1)
	var/obj/item/shard/new_item = new(user.loc)
	to_chat(user, "<span class='notice'>You take the duct tape off the [src].</span>")
	qdel(src)
	user.put_in_hands(new_item)