# -*- encoding: utf-8 -*-
$:.push File.join(File.dirname(__FILE__))

require 'date'

module Boletorb

	class NotImplementedHere < StandardError
	end

	class Cedente
		attr_accessor :nome, :banco, :agencia, :codigo_cedente, :conta, :carteira, :modalidade_carteira
	end
	
	class Sacado
		attr_accessor :documento, :nome, :endereco
	end

	class Boleto
		attr_accessor :cedente, :sacado, :nosso_numero, :numero_documento, :ios,
									:especie, :aceite, :data_processamento, :vencimento, :valor, :local_pagamento,
									:instrucao_1, :instrucao_2, :instrucao_3, :instrucao_4, :instrucao_5, :instrucao_6, :instrucao_7

		attr_reader :linha_digitavel

		def initialize
			@linha_digitavel = ""
			@ios = "0"
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
			valor_formatado = (valor * 100).to_i.to_s
			tamanho_valor = valor_formatado.size 
			for i in 1..(10 - tamanho_valor)
				valor_formatado = "0#{valor_formatado}"
			end
			valor_formatado
		end

	end

	autoload :Santander, 'boletorb/santander'

end