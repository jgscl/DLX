; Trabajo de DLX. Realizado por:
; Pablo Caño Pascual
; Juan Gil Sancho

	.data
;Espacio para los datos
;Potencias de las medias en orden: a1 cuadrado, a1 cubo etc.
potencias: .float 0.0	
	.float	0.0	
	.float	0.0
	.float	0.0	
	.float	0.0
	.float	0.0	
	.float	0.0	
	.float	0.0	
	.float	0.0	
	.float	0.0	
; VARIABLES DE ENTRADA: NO MODIFICAR ORDEN (Se pueden modificar los valores)
lista1: .float 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
lista2: .float 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
lista3: .float 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
lista4: .float 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
lista5: .float 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
;lista1: .float 12, 1,15, 1,15,13, 1,14, 1,14,14, 1,13, 1,13,15, 1,12, 1,12
;lista2: .float 2,22,25,25, 2, 2,23,24,24, 2, 2,24,23,23, 2, 2,25,22,22, 2
;lista3: .float 3, 3,32, 3, 3, 3, 3,33, 3, 3, 3, 3,34, 3, 3, 3, 3,35, 3, 3
;lista4: .float 4,45,45,42, 4, 4,44,44,43, 4, 4,43,43,44, 4, 4,42,42,45, 4
;lista5: .float 55, 5,55, 5,52,54, 5,54, 5,53,53, 5,53, 5,54,52, 5,52, 5,55

tamano: .word	20

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

	;Convertimos a float el tamano de la lista (no. de elementos)
	;para poder dividir entre él posteriormente
	; media = suma_elementos (f2) / no_elementos (f4)
	lw r5, tamano
	movi2fp f3, r5
	cvti2f f5, f3

	;Comprobamos que el denominador no es cero
	;Si es cero, se acaba el programa
	beqz r5, salir

	;CALCULO DE LAS MEDIAS
	;Registros acumuladores
	movf f1, f0
	movf f2, f0
	movf f3, f0
	movf f4, f0

	;r3 sera el contador del numero de elementos de la lista /iteraciones
	add r3, r0, r0

	;r7 contiene el desplazamiento de la lista a calcular respecto a lista1
	;que sera el punto inicial a recorrer de la lista elegida
	add r7, r0, r0
		
	;Primera iteracion cargamos y sumamos los 5 primeros elementos
	ld f6, lista1(r7)
	ld f8, lista1+8(r7)

	addi r3, r3, #5
	seq r4, r3, r5
	addf f0, f6, f7
	lf f26, lista1+16(r7)
	addf f0, f0, f8
	seq r4, r3, r5
	ld f10, lista2(r7)
	addf f0, f0, f9
	ld f12, lista2+8(r7)
	addf f0, f0, f26

	beqz r4, siguienteMedia1
		divf f0, f0, f5

	siguienteMedia1:
	lf f27, lista2+16(r7)
	addf f1, f10, f11
	addf f1, f1, f12
	ld f14, lista3(r7)
	addf f1, f1, f13
	ld f16, lista3+8(r7)
	addf f1, f1, f27

	lf f28, lista3+16(r7)
	addf f2, f14, f15
	addf f2, f2, f16
	ld f18, lista4(r7)
	addf f2, f2, f17
	ld f20, lista4+8(r7)
	addf f2, f2, f28

	lf f29, lista4+16(r7)
	addf f3, f18, f19
	addf f3, f3, f20
	ld f22, lista5(r7)
	addf f3, f3, f21
	ld f24, lista5+8(r7)
	addf f3, f3, f29

	lf f30, lista5+16(r7)
	addf f4, f22, f23
	addf f4, f4, f24
	addi r7, r7, #20
	addf f4, f4, f25
	addf f4, f4, f30

	bnez r4, medias

	;Segunda iteracion
	ld f6, lista1(r7)
	ld f8, lista1+8(r7)

	addi r3, r3, #5
	addf f0, f0, f6
	seq r4, r3, r5
	addf f0, f0, f7
	lf f26, lista1+16(r7)
	addf f0, f0, f8
	seq r4, r3, r5
	ld f10, lista2(r7)
	addf f0, f0, f9
	ld f12, lista2+8(r7)
	addf f0, f0, f26

	beqz r4, siguienteMedia2
		divf f0, f0, f5

	siguienteMedia2:
	addf f1, f1, f10
	lf f27, lista2+16(r7)
	addf f1, f1, f11
	addf f1, f1, f12
	ld f14, lista3(r7)
	addf f1, f1, f13
	ld f16, lista3+8(r7)
	addf f1, f1, f27

	addf f2, f2, f14
	lf f28, lista3+16(r7)
	addf f2, f2, f15
	addf f2, f2, f16
	ld f18, lista4(r7)
	addf f2, f2, f17
	ld f20, lista4+8(r7)
	addf f2, f2, f28

	addf f3, f3, f18
	lf f29, lista4+16(r7)
	addf f3, f3, f19
	addf f3, f3, f20
	ld f22, lista5(r7)
	addf f3, f3, f21
	ld f24, lista5+8(r7)
	addf f3, f3, f29

	addf f4, f4, f22
	lf f30, lista5+16(r7)
	addf f4, f4, f23
	addf f4, f4, f24
	addi r7, r7, #20
	addf f4, f4, f25
	addf f4, f4, f30

	bnez r4, medias

	;Tercera iteracion
	ld f6, lista1(r7)
	ld f8, lista1+8(r7)

	addi r3, r3, #5
	addf f0, f0, f6
	seq r4, r3, r5
	addf f0, f0, f7
	lf f26, lista1+16(r7)
	addf f0, f0, f8
	seq r4, r3, r5
	ld f10, lista2(r7)
	addf f0, f0, f9
	ld f12, lista2+8(r7)
	addf f0, f0, f26

	beqz r4, siguienteMedia3
		divf f0, f0, f5

	siguienteMedia3:
	addf f1, f1, f10
	lf f27, lista2+16(r7)
	addf f1, f1, f11
	addf f1, f1, f12
	ld f14, lista3(r7)
	addf f1, f1, f13
	ld f16, lista3+8(r7)
	addf f1, f1, f27

	addf f2, f2, f14
	lf f28, lista3+16(r7)
	addf f2, f2, f15
	addf f2, f2, f16
	ld f18, lista4(r7)
	addf f2, f2, f17
	ld f20, lista4+8(r7)
	addf f2, f2, f28

	addf f3, f3, f18
	lf f29, lista4+16(r7)
	addf f3, f3, f19
	addf f3, f3, f20
	ld f22, lista5(r7)
	addf f3, f3, f21
	ld f24, lista5+8(r7)
	addf f3, f3, f29

	addf f4, f4, f22
	lf f30, lista5+16(r7)
	addf f4, f4, f23
	addf f4, f4, f24
	addi r7, r7, #20
	addf f4, f4, f25
	addf f4, f4, f30

	bnez r4, medias

	;Cuarta iteracion
	ld f6, lista1(r7)
	ld f8, lista1+8(r7)

	addf f0, f0, f6
	addf f0, f0, f7
	lf f26, lista1+16(r7)
	addf f0, f0, f8
	seq r4, r3, r5
	ld f10, lista2(r7)
	addf f0, f0, f9
	ld f12, lista2+8(r7)
	addf f0, f0, f26

	divf f0, f0, f5

	addf f1, f1, f10
	lf f27, lista2+16(r7)
	addf f1, f1, f11
	addf f1, f1, f12
	ld f14, lista3(r7)
	addf f1, f1, f13
	ld f16, lista3+8(r7)
	addf f1, f1, f27

	addf f2, f2, f14
	lf f28, lista3+16(r7)
	addf f2, f2, f15
	addf f2, f2, f16
	ld f18, lista4(r7)
	addf f2, f2, f17
	ld f20, lista4+8(r7)
	addf f2, f2, f28

	addf f3, f3, f18
	lf f29, lista4+16(r7)
	addf f3, f3, f19
	addf f3, f3, f20
	ld f22, lista5(r7)
	addf f3, f3, f21
	ld f24, lista5+8(r7)
	addf f3, f3, f29

	addf f4, f4, f22
	lf f30, lista5+16(r7)
	addf f4, f4, f23
	addf f4, f4, f24
	addi r7, r7, #20
	addf f4, f4, f25
	addf f4, f4, f30

	;Aprovechamos el elevado tiempo de ejecucion de las divisiones de las medias
	;para calcular las potencias (cuadrado y cubo) de las medias y checkA
	;y para almcenar los valores de las medias
	;Potencias a1 -> en f22 y f23
	;Potencias a2 -> en f24 y f25
	;Potencias a3 -> en f26 y f27
	;Potencias a4 -> en f28 y f29
	;Potencias a5 -> en f30 y f31
	;CheckA -> acumulado sobre f10

	medias:
	divf f1, f1, f5
	multf f22, f0, f0
	multf f23, f22, f0
	divf f2, f2, f5
	multf f24, f1, f1
	multf f25, f1, f24
	multf f10, f0, f1
	divf f3, f3, f5
	multf f26, f2, f2
	multf f27, f2, f26
	multf f10, f10, f2
	divf f4, f4, f5
	multf f28, f3, f3
	sd potencias, f22
	sd potencias+8, f24
	sd potencias+16, f26
	multf f29, f3, f28
	multf f10, f10, f3
	sf a1(r0), f0
	sf a2(r0), f1
	sf a3(r0), f2
	sf a4(r0), f3
	multf f10, f10, f4
	sd potencias+24, f28
	multf f30, f4, f4
	sf a5(r0), f4
	sf checkA(r0), f10
	sd potencias+32, f30
	multf f31, f4, f30

	;Calculo del factor

	movi2fp f0, r0
	ld f12, a1
	ld f14, a3

	;Si a1 + a3 tienen valor cero se sale del programa
	;para evitar divisiones por cero
	addf f12, f12, f14
	eqf f0, f12
	;a2 + a4
	addf f13, f13, f15
	bfpt salir
	
	;El factor que luego multiplicara a cada elemento
	;de la matriz queda guardado en f13
	divf f13, f13, f12
	
	;Calculo de la matriz de vandermonde

	;f20 es el sumador para calcular checkM
	movf f20, f0
	;r7 hace de i para iterar sobre las filas de la matriz
	add r7, r0, r0

	bucle_vandermonde:
		;Primera iteracion
		
		;Calculamos en r10 en que fila (del 0-3) estamos
		;ya que con r7 iteramos con multiplos de 16
		;La operacion realizada es r10 = r7 / 16 con desplazamiento de bits
		srli r10, r7, #4
			
		;Hay una correlacion entre el numero de fila y el valor de media a calcular
		;fila 0 -> a1 (posicion 0 respecto a a1)
		;fila 1 -> a2 (posicion 4) (posicion 8 respecto a potencias)
		;fila 2 -> a3 (posicion 8) (posicion 16)
		;fila 3 -> a4 (posicion 12) (posicion 24)

		;Con r11 obtenemos el valor la media necesaria: r11 = no. columna (r10) * 4
		;con desplazamiento de bits
		slli r11, r10, #2

		;Guardamos el desplazamiento de las potencias en r14
		; r14 = no. columna * 8
		;potencias: (0)a1_cuad, (4)a1_cubo, (8)a2_cuad, (12)a2_cubo...
		slli r14, r10, #3

		;Guardamos en r15 la fila de la matriz a escribir
		;r15 = no.columna * 16 (pues cada fila ocupa 16 bytes = 4 float)
		slli r15, r10, #4

		;Multiplicamos 4 valores de la matriz (una fila) por el factor
		movf f2, f13
		lf f3, a1(r11)
		ld f4, potencias(r14)
		multf f3, f3, f13
		multf f4, f4, f13

		;Y a la vez vamos calculando checkM con los miembros ya multiplicados
		addf f20, f20, f2
		addf f20, f20, f3
		multf f5, f5, f13
		addf f20, f20, f4
		addf f20, f20, f5

		;r7 "apunta" a la siguiente fila
		addi r7, r7, #16
	
		;Una vez calculado el valor lo almacenamos en su miembro de la matriz como double
		sd M(r15), f2
		sd M+8(r15), f4

		;Segunda iteracion
		
		;Numero columna
		srli r10, r7, #4
		
		;Media a elegir
		slli r11, r10, #2
		
		;Potencias y fila de la matriz
		slli r14, r10, #3
		slli r15, r10, #4

		;Multiplicacion por factor
		movf f2, f13
		lf f3, a1(r11)
		ld f4, potencias(r14)
		multf f3, f3, f13
		multf f4, f4, f13

		;Y a la vez calculo checkM
		addf f20, f20, f2
		addf f20, f20, f3
		multf f5, f5, f13
		addf f20, f20, f4
		addf f20, f20, f5
		
		;Siguiente fila
		addi r7, r7, #16
	
		;Escribir la matriz
		sd M(r15), f2
		sd M+8(r15), f4

		;Comprobacion salida del bucle
		seqi r4, r7, #64
		beqz r4, bucle_vandermonde

	;Guardamos checkM
	sf checkM, f20

	salir:
	trap 0