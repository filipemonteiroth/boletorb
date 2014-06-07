# -*- encoding: utf-8 -*-
$:.push File.join(File.dirname(__FILE__))

require 'date'
require 'money'

module Boletorb

	class NotImplementedHere < StandardError
	end

	class Cedente
		attr_accessor :nome, :banco, :agencia, :codigo_cedente, :conta, :carteira, :modalidade_carteira, :documento
	end
	
	class Sacado
		attr_accessor :documento, :nome, :endereco

		def formatado
			"#{nome} - #{documento}"
		end

	end

	class Boleto
		attr_accessor :cedente, :sacado, :nosso_numero, :numero_documento, :ios,
									:especie, :aceite, :data_processamento, :vencimento, :valor, :local_pagamento,
									:instrucao_1, :instrucao_2, :instrucao_3, :instrucao_4, :instrucao_5, :instrucao_6, :instrucao_7

		attr_reader :linha_digitavel

		def initialize
			@linha_digitavel = ""
			@ios = "0"
			@aceite = "S"
			@especie = "DM"
		end									

		def gera
			raise NotImplementedHere
		end

		def fator_vencimento
			data_fator = DateTime.parse("07/10/1997", "DD/MM/YYYY")
			data_vencimento = DateTime.parse(vencimento, "DD/MM/YYYY")
			data_vencimento.mjd - data_fator.mjd
		end

		def valor_nominal
			valor_formatado = formata_valor_para_inteiro
			tamanho_valor = valor_formatado.size
			for i in 1..(10 - tamanho_valor)
				valor_formatado = "0#{valor_formatado}"
			end
			valor_formatado
		end

		def formata_valor_para_inteiro
			valor_formatado = (valor.round(2) * 100).to_i.to_s
		end

		def nosso_numero_formatado
			numero = nosso_numero.rjust(12, "0")
			digito_verificador = modulo_11(numero)
			"#{numero}#{digito_verificador}"
		end

		private
			def modulo_11(numero)
				numero.gsub!(".", "")
				numero.gsub!(" ", "")

				resultados = multiplicacoes_modulo_11(numero)

				soma = resultados.inject(:+)
				resto = (soma % 11)
				dv = 11 - resto
				dv = 1 if (resto == 0 || resto == 1 || resto == 10)
				dv
			end

			def modulo_10(numero)
				resultado = multiplicacoes_modulo_10(numero)
				soma = resultado.inject(:+)
				modulo = 10 - (soma % 10)
				return 0 if modulo == 10
				modulo
			end

			def multiplicacoes_modulo_11(num)
				multi = 2
				multiplicadores = []
				resultados = []
				for i in 0..(num.size - 1)
					multiplicadores << multi
					multi = multi + 1
					multi = 2 if (multi > 9)
				end
				for i in 0..num.size - 1 
					indice = num.size - 1 - i
					valor = num[indice].to_i
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

	autoload :Santander, 'boletorb/santander'

end