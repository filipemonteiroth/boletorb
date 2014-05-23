require 'boletorb'

def gera_boleto
	sacado = Boletorb::Sacado.new
	sacado.nome = "Filipe Monteiro"
	sacado.documento = "039.578.663-08"
	sacado.endereco = "Rua H 1300"
	cedente = Boletorb::Cedente.new
	cedente.banco = "033"
	cedente.agencia = "1234"
	cedente.codigo_cedente = "2113759"
	cedente.documento = "17.491.032/0001-30"
	cedente.modalidade_carteira = "102"
	cedente.carteira = "CSR"
	cedente.nome = "Grupo Caproni"
	boleto = Boletorb::Santander.new
	boleto.aceite = "S"
	boleto.especie = "DM"
	boleto.cedente = cedente
	boleto.sacado = sacado
	boleto.nosso_numero = "93000310801"
	boleto.vencimento = "24/05/2014"
	boleto.valor = 298.76
	boleto.local_pagamento = "Pagavel em qualquer banco ate o vencimento"
	boleto.gera_arquivo("boleto.pdf")
end

gera_boleto