# https://la-conjugaison.nouvelobs.com/sudoku/facile.php
# n 3095

function block(a,b)
	#defini quel block on a, entre 1 et 9
	A=floor((a-1)/3) 
	B=floor((b-1)/3) + 1
	blk = A*3 + B
	return blk
end

function iter_block(numblock, sudok)
	ls=[]
	for a in 1:9
		for b in 1:9
			if block(a,b) == numblock
				push!(ls, sudok[a,b])
			end
		end
	end
	return ls
end

function do_nothing()
	1==1
end

function seul_possib(sud_entree)
	#cherche par seule possibilite
	#sort le sudoku et si il a bougé ou pas
	all_move=false
	move = true
	while move == true
		move = false
		for a in 1:9
			for b in 1:9
				#possib = collect(1:9)
				if sud_entree == 0
					ls_possib = []
					for possib in 1:9
						if possib in sud_entree[a,:] || possib in sud_entree[:,b] || possib in iter_block(block(a,b), sud_entree)
							do_nothing()
						else
							push!(ls_possib, possib)
						end
					end
					if lenth(ls_possib)==1
						sud_entree[a,b] = ls_possib[1]
						move = true
						all_move = true
					end
				end
			end
		end
	end
	return (sud_entree, all_move)
end


function in_line(sud_entree)
	all_move=false
	move = true
	while move == true
		move = false
		#on verif chaque ligne une par une
		for a in 1:9
			#on regarde chaque valeur possib
			for c in 1:9
				#si elle est deja dans la ligne aors on s'en fout
				if c in sud_entree[a,:]
					do_nothing
				else
					possibilite=[]
					#on verif toutes les cases
					for b in 1:9
						#si y a une valeur 
						if sud_entree[a,b] != 0
							out=0
						#on regarde si il est dans d'autre col
						elseif c in sud_entree[:,b]
							out=0
						#ou dans le carre
						elseif c in iter_block(block(a,b), sud_entree)
							out=0
						#sinon c est bon
						else
							out=1
						end
						push!(possibilite, out)
					end
					#et on verifie qu il y a qu une possib
					if sum(possibilite) == 1
						#on ajoute le chrifre dans le sudoku
						sud_entree[a,:] = sud_entree[a,:] + possibilite*c
						move=true
						all_move=true
					end
				end
			end
		end
	end
	return (sud_entree, all_move)
end


function in_col(sud_entree)
	all_move=false
	move = true
	while move == true
		move = false
		#on verif chaque col une par une
		for b in 1:9
			#on regarde chaque valeur possib
			for c in 1:9
				#si elle est deja dans la col aors on s'en fout
				if c in sud_entree[:,b]
					do_nothing
				else
					possibilite=[]
					#on verif toutes les cases
					for a in 1:9
						#si y a une valeur 
						if sud_entree[a,b] != 0
							out=0
						#on regarde si il est dans d'autre col
						elseif c in sud_entree[a,:]
							out=0
						#ou dans le carre
						elseif c in iter_block(block(a,b), sud_entree)
							out=0
						#sinon c est bon
						else
							out=1
						end
						push!(possibilite, out)
					end
					#et on verifie qu il y a qu une possib
					if sum(possibilite) == 1
						#on ajoute le chrifre dans le sudoku
						sud_entree[:,b] = sud_entree[:,b] + possibilite*c
						move=true
						all_move=true
					end
				end
			end
		end
	end
	return (sud_entree, all_move)
end


function in_blk(sud_entree)
	all_move=false
	move = true
	while move == true
		move = false
		#on verif chaque blk un par un
		for blk in 1:9
			#on regarde chaque valeur possib
			for c in 1:9
				#si elle est deja dans le blk aors on s'en fout
				if c in iter_block(blk, sud_entree)
					do_nothing
				else
					possibilite=[]
					#on verif toutes les cases
					for a in 1:9
						for b in 1:9
							#si y a une valeur on s en fout
							if sud_entree[a,b] != 0
								out=0
							#si on est en dehors du block, alors on s en fout
							elseif block(a,b) != blk
								out=0
							#on regarde si il est dans d'autre col
							elseif c in sud_entree[a,:]
								out=0
							#on regarde si il est dans d'autre lin
							elseif c in sud_entree[:,b]
								out=0
							#sinon c est bon
							else
								out=1
							end
							push!(possibilite, out)
						end
					end
					#et on verifie qu il y a qu une possib
					if sum(possibilite) == 1
						#on ajoute le chrifre dans le sudoku
						possibilite = transpose(reshape(possibilite,9,9))
						sud_entree = sud_entree + possibilite*c
						move=true
						all_move=true
					end
				end
			end
		end
	end
	return (sud_entree, all_move)
end

function run(sud_entree)
	ca_bouge = true
	while ca_bouge
		sud_entree, bouge1 = seul_possib(sud_entree)
		sud_entree, bouge2 = in_col(sud_entree)
		sud_entree, bouge3 = in_line(sud_entree)
		sud_entree, bouge4 = in_blk(sud_entree)
		if bouge1 || bouge2 || bouge3 || bouge4
			ca_bouge = true
		else
			ca_bouge = false
		end
	end
	return sud_entree
end




#easy
#=sud_entree = [
0 7 0  6 8 0  0 1 0;
0 6 0  0 0 7  0 5 8;
0 8 3  4 0 5  6 2 0;

0 3 0  5 1 0  0 0 0;
0 9 1  2 0 6  5 8 0;
0 0 0  0 7 3  0 4 0;

0 1 6  8 0 9  4 7 0;
9 5 0  7 0 0  0 3 0;
0 4 0  0 5 1  0 6 0]=#

#hard
#=sud_entree = [
0 7 8  0 0 0  0 0 0;
0 0 6  3 0 7  0 0 0;
3 1 0  8 0 9  0 0 7;

4 6 0  2 9 0  3 0 1;
1 0 9  0 0 0  2 0 4;
2 0 5  0 6 1  0 7 9;

6 0 0  5 0 4  0 1 3;
0 0 0  9 0 2  5 0 0;
0 0 0  0 0 0  9 4 0
]=#

#very hard
#=sud_entree = [
5 0 6  7 8 0  2 0 1;
1 0 0  0 9 0  0 0 5;
0 0 0  5 0 0  0 9 0.

0 8 3  0 0 0  0 0 0;
9 0 0  0 0 0  0 0 2;
0 0 0  0 0 0  8 1 0;

0 3 0  0 0 8  0 0 0;
8 0 0  0 5 0  0 0 9;
6 0 1  0 2 4  7 0 3
]=#

#AI escargot
#http://www.s149505468.onlinehome.fr/sudoku_fantaisie/sudoku-le-plus-difficile.php
sud_entree=[
1 0 0  0 0 7  0 9 0;
0 3 0  0 2 0  0 0 8;
0 0 9  6 0 0  5 0 0;

0 0 5  3 0 0  9 0 0;
0 1 0  0 8 0  0 0 2;
6 0 0  0 0 4  0 0 0;

3 0 0  0 0 0  0 1 0;
0 4 0  0 0 0  0 0 7;
0 0 7  0 0 0  3 0 0
]

function hypo(sudok, deep)
	for a in 1:9
		for b in 1:9
			if sudok[a,b] == 0
				for c in 1:9
					#on cherche le plus petit non essayé possible
					if c in sudok[a,:] || c in sudok[:,b] || c in iter_block(block(a,b), sudok)
						do_nothing()
					else
						if a < 4
							println(" "^deep, deep)
						end
						new_sud = deepcopy(sudok)
						new_sud[a,b] = c
						new_sud = run(new_sud)
						
						if sum(new_sud) == 405
							sudok = new_sud
							a=string(new_sud)
							print(" ")
							print(replace(replace(replace(replace(a, "[" => ""),"]" => ""), ";" => "\n" ), ".0" => ""))
							exit(0)
						elseif 0 in new_sud
							hypo(new_sud, deep+1)
						end
					end
				end
			end
		end
	end
end



sud_entree=run(sud_entree)

if sum(sud_entree) != 405 
	hypo(sud_entree,1)

else  #si le sudoku est fini	
	a=string(sud_entree)
	print(" ")
	print(replace(replace(replace(replace(a, "[" => ""),"]" => ""), ";" => "\n" ), ".0" => ""))
end