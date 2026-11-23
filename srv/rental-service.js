const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {
  const { Cars, Rentals } = this.entities;

  // 1. Antes de criar um aluguel: valida o carro e calcula o valor total
  this.before('CREATE', Rentals, validateAndCalculateRental);

  // 2. Depois de criar um aluguel: muda o status do carro para RENTED
  this.after('CREATE', Rentals, markCarAsRented);

  // --- FUNÇÕES DE REGRA DE NEGÓCIO ---

  async function validateAndCalculateRental(req) {
    const { car_ID, startDate, endDate } = req.data;

    if (!car_ID) {
      return req.error(400, 'Selecione um carro para o aluguel.');
    }

    // Busca o carro no banco pelo ID
    const car = await SELECT.one.from(Cars).where({ ID: car_ID });

    if (!car) {
      return req.error(404, 'Carro não encontrado.');
    }

    // Verifica se está disponível (em maiúsculo ao enum)
    if (car.status !== 'AVAILABLE') {
      return req.error(400, `O carro ${car.model} não está disponível (Status: ${car.status}).`);
    }

    // Calcula a diferença de dias entre início e fim
    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));

    if (diffDays <= 0) {
      return req.error(400, 'A data final deve ser maior que a data inicial.');
    }

    // Grava o valor total calculado antes de salvar no banco
    req.data.totalPrice = diffDays * car.dailyRate;
  }

  async function markCarAsRented(data) {
    await UPDATE(Cars)
      .set({ status: 'RENTED' })
      .where({ ID: data.car_ID });
  }
});