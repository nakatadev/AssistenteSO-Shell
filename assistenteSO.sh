#!/bin/bash


limparTela(){
	clear
}
navegarDiretorio(){
	cd /home/rnakata | ls
	echo "------Qual diretorio você deseja acessar?------"
	read escolhaDRT
	cd $escolhaDRT
	ls
	echo "------O que deseja fazer agora?------"
	echo "1 - Remover arquivo\n2 - Entrar em um diretório\n3 - Sair"
	read escolhaDRT2
	if [ $escolhaDRT2 -eq 1 ];
	then
		echo "-----Digite o nome do arquivo que voce deseja remover (Digite o caminho completo)-----"
		read nomeARQ
		rm -rf $nomeARQ
		echo "Arquivo removido com sucesso!"
		echo "------O que deseja fazer agora?------"
		requisitoCS1
	elif [ $escolhaDRT2 -eq 2 ];
	then
		echo "----Digite o caminho do diretório que você deseja acessar----"
		read caminhoDRT
		cd $caminhoDRT/ | ls
		navegarDiretorio
	elif [ $escolhaDRT2 -eq 3 ];
	then
		exit
	else
		echo "Digite um numero de escolha válido!"
	fi
}
requisitoCS1(){
	echo -e "1 - Navegar pelos Diretórios\n2 - Acessar o Menu principal\n3 - Sair"
        read escolhaCS1a
        if [ $escolhaCS1a -eq 1 ];
        then
                navegarDiretorio
	elif [ $escolhaCS1a -eq 2 ];
	then
		menu
        elif [ $escolhaCS1a -eq 3 ];
        then
                exit
        else
                echo "------Digite um numero de escolha válido!!!------"
                requisitoCS1
        fi
}
requisitoCS2(){
	echo "-------------O que deseja fazer agora?-------------"
        echo -e "1 - Voltar ao Menu Principal\n2 - Sair"
        read escolhaCS2a
        if [ $escolhaCS2a -eq 1 ];
        then
                menu
        elif [ $escolhaCS2a -eq 2 ];
        then
                exit
        else
                echo "-------DIGITE UMA OPÇÃO VÁLIDA--------"
                requisitoCS2
        fi

}
menu(){
	echo "====================LISTA DE TAREFAS======================="
	echo -e "1 - Visualizar os principais diretorios\n2 - Navegar pelos diretórios\n3 - Listar processos do sistema\n4 - Monitorar servidor Apache\n5 - Verificar consumo de memória\n6 - Desligamento automático da Maquina"
	echo "-----------------------------------------------------------"
	echo "Qual tarefa você deseja executar? (1-9)"
	read escolha1
	case $escolha1 in
		1)
		cd /home/rnakata
		ls
		echo "------------------------------------------"
		echo "O que você deseja fazer agora?"
		echo -e "1 - Navegar pelos Diretórios\n2 - Sair"
		read escolhaCS1
		if [ $escolhaCS1 -eq 1 ];
		then
			navegarDiretorio
		elif [ $escolhaCS1 -eq 2 ];
		then
			exit
		else
			echo "------Digite um numero de escolha válido!!!------"
			requisitoCS1
		fi
		;;
		2)
		navegarDiretorio
		;;
		3)
		cd /home/rnakata
		ps -e
		echo "--------O que você deseja fazer agora?--------"
		echo -e "1 - Listar os 10 primeiros processos\n2 - Listar os 5 processos que estão consumindo mais memória\n3 - Voltar ao MENU Principal\n4 - Sair"
			read escolhaCS2
			case $escolhaCS2 in
				1)
				ps -e | head -n 11
				echo "-------------O que deseja fazer agora?-------------"
				echo -e "1 - Voltar ao Menu Principal\n2 - Sair"
				read escolhaCS2a
				if [ $escolhaCS2a -eq 1 ];
				then
					menu
				elif [ $escolhaCS2a -eq 2 ];
				then
					limparTela
					exit
				else
					echo "-------DIGITE UMA OPÇÃO VÁLIDA--------"
					requisitoCS2
				fi
				limparTela
				;;
				2)
				ps -e --sort -size | head -n 6
				echo "-------------O que deseja fazer agora?-------------"
              	 		echo -e "1 - Voltar ao Menu Principal\n2 - Sair"
            	  		read escolhaCS2a
          		       	if [ $escolhaCS2a -eq 1 ];
               			then
                	       	 	menu
                		elif [ $escolhaCS2a -eq 2 ];
                		then
                	        	exit
                		else
                	        	echo "-------DIGITE UMA OPÇÃO VÁLIDA--------"
                	        	requisitoCS2
                		fi
					limparTela
                		;;
				3)
					limparTela
					menu
				;;
				4)
					limparTela
					exit
				;;
				esac
		;;
		4)
			monitorarServidor
		;;
		5)
		MEMORIA=$(df -h | grep /dev/nvme0n1p2 | awk '{ print $4 }')
		echo -e "A quantidade de memoria disponível é\n -----------$MEMORIA----------"
		limparTela
		requisitoCS2
		;;
		6)
			echo "-----Digite o tempo de espera para desligar (EM MINUTOS EX: 90)-----"
			read tempoEspera
			sudo shutdown -h +$tempoEspera
		;;
		7)
			limparTela
			exit
		;;
		*)
			echo "-----DIGITE UM COMANDO VÁLIDO-----"
			menu
		;;

	esac
}
monitorarServidor(){
	respHTTP=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost)
	if [ $respHTTP -eq 200 ];
	then
		echo "Tudo OK com o servidor."
	else
		echo "Houve um problema com o servidor. Tentando reinicializar"
		sudo systemctl restart apache2
		echo "...Servidor reinicializado"
	fi
	echo "-----O que você deseja fazer agora?-----"
	echo -e "1 - Abrir servidor apache\n2 - Voltar para o menu principal\n3 - Sair"
	read escolhaCS3a
	if [ $escolhaCS3a -eq 1 ];
	then
		firefox http://localhost
	elif [ $escolhaCS3a -eq 2 ];
	then
		menu
	elif [ $escolhaCS3a -eq 3 ];
	then
		exit
	else
		echo "DIGITE UMA OPÇÃO VÁLIDA!"
	fi
}
echo "===========Olá Chefe, como posso te ajudar hoje?==========="
echo "-----------------------------------------------------------"
echo "Irei listar algumas tarefas que posso automatizar para você!"
echo "====================LISTA DE TAREFAS======================="
echo -e "1 - Visualizar os principais diretorios\n2 - Navegar pelos diretórios\n3 - Listar processos do sistema\n4 - Monitorar servidor Apache\n5 - Verificar consumo de memória\n6 - Desligamento automático da maquina\n7 - Sair"
echo "-----------------------------------------------------------"
echo "Qual tarefa você deseja executar? 1-9"
read escolha

case $escolha in
	1)
	cd /home/rnakata
	ls
	echo "------------------------------------------"
	echo "O que você deseja fazer agora?"
	echo -e "1 - Navegar pelos Diretórios\n2 - Sair"
	read escolhaCS1
	if [ $escolhaCS1 -eq 1 ];
	then
		navegarDiretorio
	elif [ $escolhaCS1 -eq 2 ];
	then
		exit
	else
		echo "------Digite um numero de escolha válido!!!------"
		requisitoCS1
	fi
	;;
	2)
	navegarDiretorio
	limpartela
	;;
	3)
	cd /home/rnakata
	ps -e
	echo "--------O que você deseja fazer agora?--------"
	echo -e "1 - Listar os 10 primeiros processos\n2 - Listar os 5 processos que estão consumindo mais memória\n3 - Voltar ao MENU Principal\n4 - Sair"
		read escolhaCS2
		case $escolhaCS2 in
			1)
				ps -e | head -n 11
				echo "-------------O que deseja fazer agora?-------------"
				echo -e "1 - Voltar ao Menu Principal\n2 - Sair"
				read escolhaCS2a
				if [ $escolhaCS2a -eq 1 ];
				then
					menu
				elif [ $escolhaCS2a -eq 2 ];
				then
					limparTela
					exit
				else
					echo "-------DIGITE UMA OPÇÃO VÁLIDA--------"
					requisitoCS2
				fi
				;;
			2)
				ps -e --sort -size | head -n 6
				echo "-------------O que deseja fazer agora?-------------"
		      	 	echo -e "1 - Voltar ao Menu Principal\n2 - Sair"
		    	  	read escolhaCS2a
		  	        if [ $escolhaCS2a -eq 1 ];
		       		then
		                	menu
		        	elif [ $escolhaCS2a -eq 2 ];
		        	then
		                	exit
		        	else
		                	echo "DIGITE UMA OPÇÃO VÁLIDA"
		                	requisitoCS2
		        	fi
		        	;;
			3)
				menu
			;;
			4)
				exit
			;;
			esac
		limparTela
	;;
	4)
		monitorarServidor
		limparTela
	;;
	5)
		MEMORIA=$(df -h | grep /dev/nvme0n1p2 | awk '{ print $4 }')
		echo -e "A quantidade de memoria disponível é\n -----------$MEMORIA----------"
		limparTela
		requisitoCS2
	;;
	6)
		echo "-----Digite o tempo de espera para desligar (EM MINUTOS EX: 90)-----"
		read tempoEspera
		sudo shutdown -h +$tempoEspera
	;;
	7)
		limparTela
		exit
	;;
	*)
		echo "-----DIGITE UM COMANDO VÁLIDO-----"
		menu
	;;
esac
