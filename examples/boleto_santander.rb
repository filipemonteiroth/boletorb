require 'boletorb'

def gera_boleto
	sacado = Boletorb::Sacado.new
	sacado.nome = "Filipe Monteiro"
	sacado.documento = "012.345.678.90"
	sacado.endereco = "Rua de Teste"
	cedente = Boletorb::Cedente.new
	cedente.banco = "033"
	cedente.agencia = "1234"
	cedente.codigo_cedente = "2113759"
	cedente.documento = "11.111.111/0001-11"
	cedente.modalidade_carteira = "102"
	cedente.carteira = "CSR"
	cedente.nome = "Empresa de teste"
	boleto = Boletorb::Santander.new
	boleto.aceite = "S"
	boleto.especie = "DM"
	boleto.cedente = cedente
	boleto.sacado = sacado
	boleto.nosso_numero = "93000310801"
	boleto.vencimento = "24/05/2014"
	boleto.valor = 13298.7612938
	boleto.local_pagamento = "Pagavel em qualquer banco ate o vencimento"
	boleto.gera_arquivo("boleto.pdf")
end

gera_boleto
