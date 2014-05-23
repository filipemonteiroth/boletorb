module Boletorb
	
	class Santander < Boletorb::Boleto
	
		def gera
			
		end

		def linha_digitavel
			campo_1 = "#{cedente.banco}99"
			campo_2 = "#{cedente.codigo_cedente[0..3]}"
			linha = "#{campo_1}.#{campo_2}"
			dv_primeiro_grupo = modulo_10("#{campo_1}#{campo_2}")

			campo_3 = "#{cedente.codigo_cedente[4..7]}"
			campo_4 = "#{nosso_numero[0..1]}.#{nosso_numero[2..6]}"
			dv_segundo_grupo = modulo_10("#{campo_3}#{campo_4}")

			restante_nosso_numero = "#{nosso_numero[7..11]}.#{nosso_numero[12..12]}"

			dv_terceiro_grupo = modulo_10("#{restante_nosso_numero}#{ios}#{cedente.modalidade_carteira}")

			dv_boleto = modulo_11("#{cedente.banco}9#{fator_vencimento}#{valor_nominal}9#{cedente.codigo_cedente}#{nosso_numero}#{ios}#{cedente.modalidade_carteira}")

			linha = "#{linha}#{dv_primeiro_grupo} #{campo_3}#{campo_4}#{dv_segundo_grupo} #{restante_nosso_numero}"
			linha = "#{linha}#{ios}#{cedente.modalidade_carteira}#{dv_terceiro_grupo} #{dv_boleto} #{fator_vencimento}#{valor_nominal}"
		end

		def modulo_11(numero)
			numero.gsub!(".", "")
			numero.gsub!(" ", "")

			resultados = multiplicacoes_modulo_11(numero)

			soma = resultados.inject(:+)
			dv = 11 - (soma % 11)
			dv = 1 if (dv == 10 || dv == 0)
			dv
		end

		def modulo_10(numero)
			resultado = multiplicacoes_modulo_10(numero)
			soma = resultado.inject(:+)
			10 - (soma % 10)
		end

		def multiplicacoes_modulo_11(num)
			multi = 2
			multiplicadores = []
			resultados = []
			for i in 0..num.size - 1
				multiplicadores << multi
				multi = multi++
				multi = 2 if (multi > 9)
			end
			for i in 0..num.size - 1 
				indice = num.size - 2 - i
				valor = num[i].to_i
				resultados << valor * multiplicadores[i]
			end
			resultados
		end

		def multiplicacoes_modulo_10(numero)
			numero.gsub!(".", "")
			numero.gsub!(" ", "")
			resultado = []
			multi = 2
			for i in 0..numero.size - 1
				valor = numero[numero.size - 1 - i].to_i * multi

				#quebrando valor em todos os casos

				while (((valor % 10) > - 1) && valor > 0)
					resultado << valor % 10
					valor = valor / 10
				end
				if (multi == 2)
					multi = 1
				else
					multi = 2
				end
			end
			resultado
		end

	end

end