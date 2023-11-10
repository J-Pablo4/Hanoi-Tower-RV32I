#Juan Pablo Lopez Zu?iga
#Miguel Ignacio Hernandez Noriega    
.equ N 3
.data
torres:
.text
main:
    #Creamos apuntador a memoria. AKA torre 1
    lui s1 %hi(torres)
    addi s1 s1 %lo(torres)
    
    #s0 es el numero de discos
    #Registros para el for loop
    addi s0 zero N
    add t2 zero s0 #Registro temporal para guardar discos en memoria
    add t0 zero zero #Contador del for_loop
    
    
for_loop:
    #Guardamos discos en la torre 1
    #Alineamos memoria
    slli t1 t0 2
    add t1 s1 t1 
    
    #Aumentamos el contador del for_loop en 1
    addi t0 t0 1
    
    #Guardamos discos en memoria
    sw t2 0(t1)
    
    # Decrementamos el valor del numero de discos
    addi t2 t2 -1
    
    #Condicion del for_loop
    blt t0 s0 for_loop
    
    #Aumentamos el apuntador de la torre 1 en 4 para
    #posicionar al apuntador una direccion despues
    #de la ultima de donde se guardo el ultimo disco en
    #la torre 1
    addi s1 t1 4
    
    #Torre 2
    addi s2 t1 16
    
    #Torre 3
    slli t3 s0 2
    addi t3 t3 12
    add t3 s2 t3
    add s3 zero t3
    
    #Argumentos para la funcion
    add a0 zero s0 #n
    add a1 zero s1 #torre 1 
    add a2 zero s2 #torre 2
    add a3 zero s3 #torre 3
    
    #Primera llamada a la funcion hanoi
    jal ra hanoi
    jal zero exit #Fin del programa
    
hanoi:
    #Push al stack
    addi sp sp -20
    sw s0 16(sp)#numero de discos
    sw s1 12(sp)#torre 1
    sw s2 8(sp)#torre 2
    sw s3 4(sp)#torre 3
    sw ra 0(sp)#direccion de retorno
    
    #Igualamos los argumentos de la funcion
    #a los registros que se guardan en el stack
    add s0 a0 zero
    add s1 a1 zero
    add s2 a2 zero
    add s3 a3 zero
    
    #Caso Base if (n == 1)
    addi t1 zero 1
    beq a0 t1 base_case
    
    #Swapping de torres para la segunda llamada de la
    #funcion hanoi
    #hanoi(n - 1, origen, destino, auxiliar)
    add t0 a2 zero
    add a2 a3 zero
    add a3 t0 zero
    
    #Decremento de n
    #N - 1
    addi a0 a0 -1
    #Llamada a funcion hanoi
    jal ra hanoi
    
    #Correccion de apuntadores.
    #Se corrigen los apuntadores y se posicionan una
    #direccion despues del ultimo disco guardado en cada
    #una de las torres
    add s1 zero a1
    add s2 zero a3
    add s3 zero a2
    
    #Se corrigen los argumentos y se alinean con los apuntadores
    #de las torres de los registros s
    add a0 zero s0 #a0 corresponde a s0. Numero de disco
    add a1 zero s1 #a1 corresponde a s1. 
    add a2 zero s2 #a2 corresponde a s2
    add a3 zero s3 #a3 corresponde a s3
    
    #Swapping de discos
    addi a1 a1 -4 #Direccion del ultimo disco guardado en la torre origen
    lw t2 0(a1) #Se guarda el valor del disco en registro temporal
    sw zero 0(a1) #Se borra el disco de la torre origen
    
    sw t2 0(a3) #Se guarda el disco en la torre destino
    addi a3 a3 4 #Direccion despues del ultimo disco guardado en la torre destino
    
    #Se actualizan los registros que se guardan en el stack
    #antes de hacer llamada a la funcion hanoi
    add s1 zero a1
    add s2 zero a2
    add s3 zero a3
    
    #Swapping de torres para la tercera llamada de la
    #funcion hanoi
    #hanoi(n - 1, auxiliar, origen, destino)
    add t0 a1 zero
    add a1 a2 zero
    add a2 t0 zero
    
    #Decremento de n
    #N - 1
    addi a0 a0 -1
    #Llamada a funcion hanoi
    jal ra hanoi
    
    #Swapping de torres de los argumentos para el retorno de funcion
    #Esto se hace con el objtivo de que las instrucciones de
    #la linea 98 a la 100 funcionen debidamente
    add t0 a1 zero
    add a1 a2 zero
    add a2 t0 zero
    
    #Retorno de funcion
    jal ra base_case_return
    
base_case:
    #Swapping de discos
    addi a1 a1 -4 #Direccion del ultimo disco guardado en la torre origen
    lw t2 0(a1) #Se guarda el valor del disco en registro temporal
    sw zero 0(a1) #Se borra el disco de la torre origen
    
    sw t2 0(a3) #Se guarda el disco en la torre destino
    addi a3 a3 4 #Direccion despues del ultimo disco guardado en la torre destino
    
base_case_return:
    #Pops del stack
    lw ra 0(sp)
    lw s3 4(sp)
    lw s2 8(sp)
    lw s1 12(sp)
    lw s0 16(sp)
    addi sp sp 20
    
    #Retorno de funcion
    jalr zero ra 0
    
exit:
    jal zero exit #Fin del programa
