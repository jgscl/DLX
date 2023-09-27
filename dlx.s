; Trabajo de DLX. Realizado por:
; Pablo Caño Pascual
; Juan Gil Sancho

	.data
;Espacio para los datos
; VARIABLES DE ENTRADA: NO MODIFICAR ORDEN (Se pueden modificar los valores)
;lista1: .float 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
;lista2: .float 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
;lista3: .float 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
;lista4: .float 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
;lista5: .float 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
lista1: .float 12, 1,15, 1,15,13, 1,14, 1,14,14, 1,13, 1,13,15, 1,12, 1,12
lista2: .float 2,22,25,25, 2, 2,23,24,24, 2, 2,24,23,23, 2, 2,25,22,22, 2
lista3: .float 3, 3,32, 3, 3, 3, 3,33, 3, 3, 3, 3,34, 3, 3, 3, 3,35, 3, 3
lista4: .float 4,45,45,42, 4, 4,44,44,43, 4, 4,43,43,44, 4, 4,42,42,45, 4
lista5: .float 55, 5,55, 5,52,54, 5,54, 5,53,53, 5,53, 5,54,52, 5,52, 5,55

tamano: .word 20

;;;;; VARIABLES DE SALIDA: NO MODIFICAR ORDEN
; m11, m12, m13, m14
; m21, m22, m23, m24
; m31, m32, m33, m34
; m41, m42, m43, m44
M: .float 0.0, 0.0, 0.0, 0.0
.float 0.0, 0.0, 0.0, 0.0
.float 0.0, 0.0, 0.0, 0.0
.float 0.0, 0.0, 0.0, 0.0
checkM: .float 0.0
; Medias
a1: .float 0.0
a2: .float 0.0
a3: .float 0.0
a4: .float 0.0
a5: .float 0.0
checkA: .float 0.0
;;;;; FIN NO MODIFICAR ORDEN
	.text
;Espacio para el codigo
	.global main

main:
	;Primero ponemos f0 = 0.0 para que tenga un valor fijo como r0
	movi2fp f0, r0

	;Calculo de las medias aritmeticas: a1, a2, a3, a4 y a5

	;Cargamos en r1 la direccion de la lista a sacar la media
	;y en r2 la direccion donde se almacenara la media
	addi r6, r0, a1
	addi r1, r0, lista1
	addi r2, r0, a1
	jal calcular_media

	addi r1, r0, lista2
	addi r2, r0, a2
	jal calcular_media

	addi r1, r0, lista3
	addi r2, r0, a3
	jal calcular_media

	addi r1, r0, lista4
	addi r2, r0, a4
	jal calcular_media

	addi r1, r0, lista5
	addi r2, r0, a5
	jal calcular_media

	jal calcular_vandermonde
	jal factor_matriz
	jal final_matriz

	jal calcular_checkA
	jal calcular_checkM

	salir:
	trap 0

; Para calcular las medias
;Registros a usar
;r1 -> direccion de la lista que vamos a usar
;r2 -> direccion de variable de la media
;r3 -> contador de iteraciones
;r4 -> elemento de comparacion
;r5 -> tamano de la lista (en elementos .float)
;r6 -> direccion de a1
;r7 -> contador (de bytes)
;f1 -> elemento de la lista
;f2 -> suma de elementos de la lista
;f3 -> media a calcular
;f4 -> tamano de la lista en float (en elementos .float)
calcular_media:
	;f2 = 0.0 que sera el registro que almacenara la suma de la media
	movf f2, f0

	;r3 sera el contador del numero de elementos de la lista /iteraciones
	add r3, r0, r0

	;r7 contiene el desplazamiento de la lista a calcular respecto a lista1
	;que sera el punto inicial a recorrer de la lista elegida
	subi r7, r1, lista1

	;Convertimos a float el tamano de la lista (no. de elementos)
	;para poder dividir entre él posteriormente
	; media = suma_elementos (f2) / no_elementos (f4)
	lw r5, tamano
	movi2fp f3, r5
	cvti2f f4, f3

	;Comprobamos que el denominador no es cero
	;Si es cero, se acaba el programa
	beqz r5, salir

	;En vez de multiplicar desplazamos dos bytes a la izda
	;que es igual que multiplicar por dos dos veces y se tarda menos
	;slli r5, r5, #2

	;Cargamos el elemento de la lista y lo añadimos a la suma
	bucle_media:
		lf f1, lista1(r7)
		addf f2, f2, f1
		addi r7, r7, #4
		addi r3, r3, #1

		;Se acaba el bucle si r3 == r5 (numero de elementos / bytes de la lista)
		seq r4, r3, r5
		beqz r4, bucle_media
	divf f3, f2, f4

	;Ahora en r2 calculamos el desplazamiento frente a a1
	;para poder guardar en ax = a1 + desplazamiento (r2) la media
	sub r2, r2, r6
	sf a1(r2), f3
	jr r31

;r6 -> direccion de M
;Iterar matriz: i = r7, j = r8, r9 = r7 + r8
;r10 -> 1 - auxiliar, final - 
;r2 -> almacena direccion lista a1
;r4 -> para realizar comparaciones
;r5 -> numero de elementos de la lista
;f5 ->
;f6 -> contiene el 1 en decimal
calcular_vandermonde:
	;r7 hace de i y r8 de j para iterar sobre la matriz
	;r9 = r7 + r8, para acceder a los elementos
	add r7, r0, r0
	add r8, r0, r0

	;En r2 guardamos la direccion de a1
	addi r2, r0, a1

	;Convertimos el 1 a decimal
	;Utilizamos f6 exclusivamente para añadir el 1.0
	addi r10, r0, #1
	movi2fp f5, r10
	cvti2f f6, f5

	bucle_vandermonde:
		;Si la columna es cero, el valor de M[i][0] vale 1
		add r9, r7, r8
		;if(r8 == 0)
		bnez r8, resto_col
			sf M(r9), f6
			j fin_iteracion
		;else
		resto_col:
			;Calculamos en r10 en que fila (del 0-3) estamos
			;ya que con r7 iteramos con multiplos de 16
			addi r10, r0, #16
			div r10, r7, r10
			
			;Hay una correlacion entre el numero de fila y el valor de media a calcular
			;fila 0 -> a1 (posicion 0 respecto a a1)
			;fila 1 -> a2 (posicion 4)
			;fila 2 -> a3 (posicion 8)
			;fila 3 -> a4 (posicion 12)
			addi r12, r0, #4
			mult r11, r12, r10
			lf f7, a1(r11)

			;Para calcular las potencias se van a ir acumulando las multiplicaciones
			;en el registro f8 = 1.0 (inicialmente)
			addi r13, r0, #1
			movi2fp f9, r13
			cvti2f f8, f9
			add r13, r0, r0

			;Este bucle en C seria algo así
			;for(x = 0; x < j; x+=4) valiendo j un multiplo de 4
			;y donde x = r13 y j = r8
			bucle_potencias:
				;Multiplicamos aux = aux (f8) * aX (f7)
				multf f8, f8, f7
				addi r13, r13, #4
				slt r4, r13, r8
				bnez r4, bucle_potencias

			;Una vez calculado el valor lo almacenamos en su miembro de la matriz
			sf M(r9), f8
		;Actualizacion de los indices i(r7) y j(r8)
		;r4 se usara como destino para las comparaciones
		fin_iteracion:
			addi r8, r8, #4
			;if(r8 == 16)
			;Es decir, si r8 ha pasado la ultima columna...
			seqi r4, r8, #16
			beqz r4, condicion_salida

			;... se aumenta una fila i += 1 aka r7 = r7 +16
			;y r8 se situa en la primera columna r8 = 0
				addi r7, r7, #16
				add r8, r0, r0
			;Comprobacion de la condicion de salida
			;if(r7 == 64)
			;Es decir, si r7 ha pasado la ultima columna
			condicion_salida:
				seqi r4, r7, #64
				beqz r4, bucle_vandermonde
			jr r31

calcular_checkM:
	;Utilizamos r14 para iterar sobre todos los elementos de la matriz
	add r14, r0, r0
	;Y a f11 como acumulador de la suma de los elementos de la matriz
	addf f11, f0, f0
	bucle_check_m:
		lf f10, M(r14)
		addf f11, f10, f11
		addi r14, r14, #4
		seqi r4, r14, #64
		beqz r4, bucle_check_m
		;Guardamos la suma en checkM
		sf checkM, f11
		jr r31

;Lo mismo que calcular_checkM pero con multiplicaciones y menos elementos
calcular_checkA:
	add r14, r0, r0
	;El acumulador es ahora f11 y lo copiamos de f6 que vale 1.0
	movf f11, f6
	bucle_check_a:
		lf f10, a1(r14)
		multf f11, f10, f11
		addi r14, r14, #4
		seqi r4, r14, #20
		beqz r4, bucle_check_a
		sf checkA, f11
		jr r31

;Calculamos aquí la otra operacion que hay que hacer junto a
;la matriz de vandermonde
factor_matriz:
	lf f12, a1
	lf f13, a2
	lf f14, a3
	lf f15, a4
	lf f16, a5

	;Si a5 o a1 +a3 tienen valor cero se sale del programa
	;para evitar divisiones por cero
	addf f17, f12, f14
	eqf f0, f17
	bfpt salir
	eqf f0, f16
	bfpt salir
	
	;a1/a5
	divf f12, f12, f16
	;a2/a5
	divf f13, f13, f16
	;a3/a5
	divf f14, f14, f16
	;a4/a5
	divf f15, f15, f16

	;a2/a5 + a4/a5
	addf f13, f13, f15

	;a1/a5 + a3/a5
	addf f12, f12, f14
	;El factor que luego multiplicara a cada elemento
	;de la matriz queda guardado en f13
	divf f13, f13, f12
	jr r31

;Multiplicamos aqui cada elemento de la matriz de vandermonde
;con el factor calculado anteriormente y guardado en f13
final_matriz:
	add r14, r0, r0
	bucle_final_matriz:
		lf f16, M(r14)
		multf f16, f16, f13
		sf M(r14), f16
		add r14, r14, #4
		seqi r4, r14, #64
		beqz r4, bucle_final_matriz
		jr r31