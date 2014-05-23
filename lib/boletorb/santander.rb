require 'thinreports'
require 'open-uri'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/png_outputter'

module Boletorb
	
	class Santander < Boletorb::Boleto
	
		def gera
			layout_processado = processa_layout
			layout_processado.generate
		end

		def gera_arquivo(nome_do_arquivo)
			layout_processado = processa_layout	
			layout_processado.generate filename: nome_do_arquivo
		end

		def linha_digitavel
			campo_1 = "#{cedente.banco}99"
			campo_2 = "#{cedente.codigo_cedente[0..3]}"
			linha = "#{campo_1}.#{campo_2}"
			dv_primeiro_grupo = modulo_10("#{campo_1}#{campo_2}")

			campo_3 = "#{cedente.codigo_cedente[4..7]}"
			campo_4 = "#{nosso_numero_formatado[0..1]}.#{nosso_numero_formatado[2..6]}"
			dv_segundo_grupo = modulo_10("#{campo_3}#{campo_4}")

			restante_nosso_numero = "#{nosso_numero_formatado[7..11]}.#{nosso_numero_formatado[12..12]}"

			dv_terceiro_grupo = modulo_10("#{restante_nosso_numero}#{ios}#{cedente.modalidade_carteira}")

			dv_boleto = modulo_11("#{cedente.banco}9#{fator_vencimento}#{valor_nominal}9#{cedente.codigo_cedente}#{nosso_numero_formatado}#{ios}#{cedente.modalidade_carteira}")

			linha = "#{linha}#{dv_primeiro_grupo} #{campo_3}#{campo_4}#{dv_segundo_grupo} #{restante_nosso_numero}"
			linha = "#{linha}#{ios}#{cedente.modalidade_carteira}#{dv_terceiro_grupo} #{dv_boleto} #{fator_vencimento}#{valor_nominal}"
		end

		def codigo_de_barras
			dv_boleto = modulo_11("#{cedente.banco}9#{fator_vencimento}#{valor_nominal}9#{cedente.codigo_cedente}#{nosso_numero_formatado}#{ios}#{cedente.modalidade_carteira}")
			codigo = "#{cedente.banco}9#{dv_boleto}#{fator_vencimento}#{valor_nominal}9#{cedente.codigo_cedente}#{nosso_numero_formatado}#{ios}#{cedente.modalidade_carteira}"			
			codigo
		end

		private
			def processa_layout
				report = ThinReports::Report.new layout: "#{File.dirname(__FILE__)}/templates/santander.tlf"
				report.start_new_page do |page|
					page.item(:banco_img).src("#{File.dirname(__FILE__)}/images/santander.jpg")
					page.item(:banco_img_rp).src("#{File.dirname(__FILE__)}/images/santander.jpg")
					puts "Codigo de barras: #{codigo_de_barras}"
					code = Barby::Code25Interleaved.new(codigo_de_barras)
					barcode = StringIO.new(code.to_png({:height => 200, :xdim => 5, :margin => 5}))
					page.item(:cod_barras).src(barcode)
					page.values banco: cedente.banco,										
											banco_rp: cedente.banco,
											linha_digitavel: linha_digitavel,
											linha_digitavel_rp: linha_digitavel,
											cedente: cedente.nome,
											cedente_rp: cedente.nome,
											agencia_conta: "#{cedente.agencia}/#{cedente.codigo_cedente}",
											agencia_conta_rp: "#{cedente.agencia}/#{cedente.codigo_cedente}",
											nosso_numero: nosso_numero_formatado,
											nosso_numero_rp: nosso_numero_formatado,
											numero_documento: numero_documento,
											numero_documento_rp: numero_documento,
											especie_documento: especie,
											aceite: aceite,
											data_processamento: data_processamento,
											cpf_cnpj: cedente.documento,
											vencimento: vencimento,
											vencimento_rp: vencimento,
											valor_documento: "R$ #{valor}",
											valor_documento_rp: "R$ #{valor}",
											sacado_formatado: sacado.formatado,
											sacado_formatado_rp: sacado.formatado,
											endereco_sacado: sacado.endereco,
											endereco_sacado_rp: sacado.endereco,
											local_pagamento: local_pagamento,
											carteira: cedente.modalidade_carteira,
											instrucao_1: instrucao_1,
											instrucao_2: instrucao_2,
											instrucao_3: instrucao_3,
											instrucao_4: instrucao_4,
											instrucao_5: instrucao_5,
											instrucao_6: instrucao_6,
											instrucao_7: instrucao_7
				end
				report
			end
	end

end