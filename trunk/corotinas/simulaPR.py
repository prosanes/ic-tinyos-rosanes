import sys #importa o pacote de I/O do Python
from TOSSIM import * #importa o modulo que implementa o Tossim
t = Tossim([]) #cria um objeto Tossim (sem argumentos)
m = t.getNode(5) #cria um mote com ID 5
m.bootAtTime(45654) #mote 5 ira iniciar apos 45654 ticks do simulador
f = open("log", "w")
t.addChannel("Timer",sys.stdout) #liga o canal "Boot" aa saida padrao
t.runNextEvent() #executa o proximo evento (inicia o mote 5)
while (m.isOn()): #entra no loop de execucao de eventos do simulador
    t.runNextEvent() #executa o proximo evento
