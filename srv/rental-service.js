const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {
 const { Cars, Rentals } = this.entities;

 // 1. Antes de criar um aluguel: valida o carro e calcula o valor total
 this.before('CREATE', Rentals, ValidadeAndCalculateRental);

 // 2. Depois de criar um aluguel: muda o status do carro para RENTED
 this.after('CREATE', Rentals, markCarAsRented);

 // --- FUNÇÕES DE REGRA DE NEGÓCIO ---
 async function validateAndCalculateRental(req) {
  const { car_ID, startDate, endDate } = req.data;

  if(!card_ID) {
    return req.error(400)
  }
 }
});