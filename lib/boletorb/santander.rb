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
	end

end