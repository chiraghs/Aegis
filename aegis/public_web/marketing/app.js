// Aegis Marketing Site Interactive Engine

document.addEventListener('DOMContentLoaded', () => {
  // 1. Vehicle Garage Interactive Switcher
  const vehicleData = {
    tesla: {
      name: 'Tesla Model 3 Performance',
      vin: '5YJ3E1EB8KF194821',
      img: 'assets/tesla_model_3.jpg',
      valuation: '$48,200',
      specs: {
        powertrain: 'Dual Motor AWD',
        range: '315 Miles EPA',
        safety: '5-Star NHTSA Overall',
        recalls: '0 Active Bulletins'
      }
    },
    porsche: {
      name: 'Porsche Taycan 4S Electric',
      vin: 'WP0AB2Y14MSA83921',
      img: 'assets/porsche_taycan.jpg',
      valuation: '$112,500',
      specs: {
        powertrain: '800V Performance Plus',
        range: '246 Miles EPA',
        safety: 'Porsche Active Shield',
        recalls: '0 Active Bulletins'
      }
    },
    mustang: {
      name: 'Ford Mustang GT Premium',
      vin: '1FA6P8CF5L5100000',
      img: 'assets/mustang_gt.jpg',
      valuation: '$54,900',
      specs: {
        powertrain: '5.0L Coyote V8 480hp',
        range: 'MagnaRide Track System',
        safety: 'Ford Co-Pilot360',
        recalls: '0 Active Bulletins'
      }
    }
  };

  const garageTabs = document.querySelectorAll('.garage-tab-btn');
  const vehicleImg = document.getElementById('garageVehicleImg');
  const vehicleName = document.getElementById('garageVehicleName');
  const vehicleVin = document.getElementById('garageVehicleVin');
  const vehicleVal = document.getElementById('garageVehicleVal');
  const vehiclePower = document.getElementById('garageVehiclePower');
  const vehicleRange = document.getElementById('garageVehicleRange');
  const vehicleSafety = document.getElementById('garageVehicleSafety');

  garageTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      garageTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');

      const carKey = tab.dataset.vehicle;
      const data = vehicleData[carKey];
      if (!data) return;

      vehicleImg.style.opacity = '0.4';
      setTimeout(() => {
        vehicleImg.src = data.img;
        vehicleName.textContent = data.name;
        vehicleVin.textContent = 'VIN: ' + data.vin;
        vehicleVal.textContent = data.valuation;
        vehiclePower.textContent = data.specs.powertrain;
        vehicleRange.textContent = data.specs.range;
        vehicleSafety.textContent = data.specs.safety;
        vehicleImg.style.opacity = '1';
      }, 150);
    });
  });

  // 2. Interactive Coin Minting Calculator
  const spendSlider = document.getElementById('spendSlider');
  const spendDisplay = document.getElementById('spendDisplay');
  const coinsMintedDisplay = document.getElementById('coinsMintedDisplay');
  const goldCoinsDisplay = document.getElementById('goldCoinsDisplay');

  function updateCalculator() {
    if (!spendSlider) return;
    const spend = parseInt(spendSlider.value, 10);
    spendDisplay.textContent = '$' + spend.toLocaleString() + ' / month';

    // 1 dollar = 1 coin baseline, 2x for Gold Pass
    const annualSpend = spend * 12;
    const standardCoins = annualSpend;
    const goldCoins = annualSpend * 2;

    coinsMintedDisplay.textContent = standardCoins.toLocaleString();
    goldCoinsDisplay.textContent = goldCoins.toLocaleString() + ' Coins';
  }

  if (spendSlider) {
    spendSlider.addEventListener('input', updateCalculator);
    updateCalculator();
  }

  // 3. FAQ Accordion
  const faqItems = document.querySelectorAll('.faq-item');
  faqItems.forEach(item => {
    const question = item.querySelector('.faq-question');
    question.addEventListener('click', () => {
      const isActive = item.classList.contains('active');
      faqItems.forEach(i => i.classList.remove('active'));
      if (!isActive) {
        item.classList.add('active');
      }
    });
  });
});
