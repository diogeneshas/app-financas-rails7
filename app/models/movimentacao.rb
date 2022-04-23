class Movimentacao < ApplicationRecord
  enum :tipo, { saida: 'saida', entrada: 'entrada' }
  # enum tipo: %i[saida entrada]

  validate :valida_se_existe_saldo
  validates :data, comparison: { less_than_or_equal_to: proc { Date.current } }
  validates :descricao, presence: true, length: { maximum: 150 }
  validates :valor, presence: true
  validates :tipo, presence: true

  def self.saldo_atual
    entrada.sum(:valor) - saida.sum(:valor)
  end

  private

  def valida_se_existe_saldo
    return if entrada?
    return if valor.to_f <= Movimentacao.saldo_atual

    errors.add :valor, 'nao ha saldo suficiente'
  end
end
