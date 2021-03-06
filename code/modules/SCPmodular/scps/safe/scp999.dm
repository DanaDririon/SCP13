#define HUGGING 1

/mob/living/simple_animal/scp_999
	name = "SCP-999"
	desc = "A happy, blorbling hug monster."
	icon = 'code/modules/SCPmodular/spcicon/scpmobs/scp-999.dmi'
	icon_state = "SCP-999"
	icon_living = "SCP-999"
	icon_dead = "SCP-999_dead"
	alpha = 200
	maxHealth = 15000
	health = 15000
	hud_type = HUD_MEDICAL
	var/mob/living/carbon/attached
	var/attached_mode = HUGGING
	var/list/last_healing = list()

/mob/living/simple_animal/scp_999/update_icon()
	if(stat != DEAD && resting)
		icon_state = "SCP-999_rest"
	else if(stat == DEAD)
		icon_state = "SCP-999_dead"
	else
		icon_state = "SCP-999"

/mob/living/simple_animal/scp_999/examine(mob/user)
	user << "<b><span class = 'success'>SCP-999</span></b> - [desc]"

mob/living/simple_animal/scp_999/UnarmedAttack(atom/a)
	if(ishuman(a))
		if(a_intent == I_HELP)
			attached_mode = HUGGING
			attached = a
			a.visible_message("<span class='notice'>[src] begins to give [attached] a big hug!</span>", "<span class='notice'>[src] begins hugging you, filling you with happiness!</span>")
			forceMove(attached.loc)

/mob/living/simple_animal/scp_999/Life()
	. = ..()
	if(attached)
		forceMove(attached.loc)
		if(last_healing[attached] == null || ((last_healing[attached] + 2 MINUTES) >= world.time))
			last_healing[attached] = world.time
			if(attached_mode == HUGGING)
				attached.adjustOxyLoss(-rand(20,30))
				attached.adjustToxLoss(-rand(20,30))
				attached.adjustBruteLoss(-rand(20,30))
				attached.adjustFireLoss(-rand(20, 30))
				attached.adjustHalLoss(-200)
				to_chat(attached, "<span class='notice'>You feel your injuries healing and becoming numb...</span>")
				attached.emote(pick("laugh","giggle","smile","grin"))

/mob/living/simple_animal/scp_999/Move(a,b,f)
	if(attached)
		if(attached_mode == HUGGING)
			to_chat(src, "<span class='notice'>You are hugging someone! Detach to move!</span>")
			return
		else
			if(prob(1))
				attached.Move(a,b,f)
			return
	return ..(a,b,f)

/mob/living/simple_animal/scp_999/verb/detach()
	set category = "SCP"
	set name = "Stop Hugging"
	if(attached)
		forceMove(get_turf(src))
		visible_message("<span class='notice'>[src] stopps hugging [attached]!</span>")
		attached = null
	else
		to_chat(src, "<span class='warning'><i>You arent attached to anything!</i></span>")
#undef HUGGING