#require 'spec_helper'
require 'minitest/autorun'
require File.expand_path('../lib/boletorb')
require File.expand_path('../lib/boletorb/santander')

describe Boletorb::Santander do

	describe '#linha_digitavel' do

		before do
			@boleto = boleto_santander
		end

		describe "Grupo 1" do			
			it "deveria adicionar o banco e moeda ao inicio da linha digitavel" do
				@boleto.linha_digitavel[0..5].must_equal "03399."
			end

			it "deveria adicionar os primeiros quatro digitos do codigo do cedente santander" do
				@boleto.linha_digitavel[0..9].must_equal "03399.2113"
			end

			it "deveria calcular o digito verificado do primeiro grupo" do
				@boleto.linha_digitavel[0..10].must_equal "03399.21132"
			end
		end

		describe "Grupo 2" do
			it "deveria adicionar o restante do codigo do cedente" do
				@boleto.linha_digitavel[0..14].must_equal "03399.21132 759"
			end

			it "deveria adicionar os 7 primeiro digitos do nosso numero" do
				@boleto.linha_digitavel[0..22].must_equal "03399.21132 75909.30003"
			end

			it "deveria adicionar digito verificador do segundo grupo" do
				@boleto.linha_digitavel[0..23].must_equal "03399.21132 75909.300032"
			end
		end

		describe "Grupo 3" do
			it "deveria adicionar o restante do nosso numero" do
				@boleto.linha_digitavel[0..31].must_equal "03399.21132 75909.300032 10800.6"
			end

			it "deveria adicionar ios" do
				@boleto.linha_digitavel[0..32].must_equal "03399.21132 75909.300032 10800.60"
			end

			it "deveria adicionar a modalidade da carteira" do
				@boleto.linha_digitavel[0..35].must_equal "03399.21132 75909.300032 10800.60102"
			end

			it "deveria gerar o digito verificador do terceiro grupo" do
				@boleto.linha_digitavel[0..36].must_equal "03399.21132 75909.300032 10800.601022"
			end
		end

		describe "Grupo 4" do
			it "deveria gerar o digito verificador do boleto" do
				@boleto.linha_digitavel[0..39].must_equal "03399.21132 75909.300032 10800.601022 6 "
			end
		end

		describe "Grupo 5" do
			it "deveria adicionar o fator de vencimento e valor nominal a linha digitavel" do
				@boleto.linha_digitavel.must_equal "03399.21132 75909.300032 10800.601022 6 60730000029876"
			end
		end
	end

	describe "#codigo_de_barras" do
		before do
			@boleto = boleto_santander
		end

		it "deveria retornar o codigo de barras com 44 posicoes" do
			codigo_de_barras = @boleto.codigo_de_barras
			codigo_de_barras.size.must_equal 44
			codigo_de_barras.must_equal "03396607300000298769211375909300031080060102"
		end
	end

end

def boleto_santander
	cedente = Boletorb::Cedente.new
	cedente.banco = "033"
	cedente.codigo_cedente = "2113759"
	cedente.modalidade_carteira = "102"
	boleto = Boletorb::Santander.new
	boleto.cedente = cedente
	boleto.nosso_numero = "93000310800"
	boleto.vencimento = "24/05/2014"
	boleto.valor = 298.763829408324234
	boleto
end

def boleto_santander_com_digito_1
	sacado = Boletorb::Sacado.new
	sacado.nome = "Filipe Monteiro"
	sacado.documento = "039.578.663-08"
	sacado.endereco = "Rua H 1300"
	cedente = Boletorb::Cedente.new
	cedente.banco = "033"
	cedente.codigo_cedente = "2113759"
	cedente.modalidade_carteira = "102"
	cedente.carteira = "ECR"
	boleto = Boletorb::Santander.new
	boleto.cedente = cedente
	boleto.sacado = sacado
	boleto.nosso_numero = "93000310801"
	boleto.vencimento = "24/05/2014"
	boleto.valor = 298.762193091238019238
	boleto
end