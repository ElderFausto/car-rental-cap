const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {
  const { Cars, Rentals } = this.entities;

  // 1. Índice de eventos: mostra rapidamente o que o serviço faz
  this.before('CREATE', Rentals, validateAndCalculateRental);
  this.after('CREATE', Rentals, markCarAsRented);

  // 2. Implementação das funções de negócio
  async function validateAndCalculateRental(req) {
    const { car_ID, startDate, endDate } = req.data;

    if (!car_ID) {
      return req.error(400, 'CarRequired');
    }

    const car = await SELECT.one.from(Cars).where({ ID: car_ID });

    if (!car) {
      return req.error(404, 'CarNotFound');
    }

    if (car.status !== 'AVAILABLE') {
      return req.error(400, 'CarNotAvailable', [car.model, car.status]);
    }

    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));

    if (diffDays <= 0) {
      return req.error(400, 'InvalidDates');
    }

    req.data.totalPrice = diffDays * car.dailyRate;
  }

  async function markCarAsRented(data, req) {
    const carId = req?.data?.car_ID || data?.car_ID;
    if (carId) {
      await UPDATE(Cars)
        .set({ status: 'RENTED' })
        .where({ ID: carId });
    }
  }
});