import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables);

/* Connects to data-controller="statistic-chart"
 *
 * Draws chart for given transction data
 */
export default class extends Controller {

  static targets = ["data", "chart"]

  static values = {
    group: String
  }

  connect() {
    this.buildChart(this.groupValue === 'date');
  }
  buildChart(swap) {
    let data = JSON.parse(this.dataTarget.innerText);
    data.forEach(d => d.amount = d.amount / 100);
    let groups = [...new Set(data.map(l => l.category))].sort(); // categories
    let xValue = [...new Set(data.map(l => l.dupe))].sort(); // dates
    if (swap) {
      let tmp = groups;
      groups = xValue;
      xValue = tmp;
      xValue.forEach(c => groups.forEach(d => { if (!data.find(t => t.dupe === d && t.category === c)) data.push({category: c, dupe: d, amount: 0})}));
      data = data.reduce((r, l) => {
        if (!r[l.dupe]) {
          r[l.dupe] = [];
        }
        r[l.dupe].push(l)
        r[l.dupe] = r[l.dupe].sort((l,r) => l.category.localeCompare(r.category));
        return r;
      }, {});
    } else {
      xValue.forEach(d => groups.forEach(c => { if (!data.find(t => t.dupe === d && t.category === c)) data.push({category: c, dupe: d, amount: 0})}));
      data = data.reduce((r, l) => {
        if (!r[l.category]) {
          r[l.category] = [];
        }
        r[l.category].push(l);
        r[l.category] = r[l.category].sort((l,r) => l.dupe.localeCompare(r.dupe));
        return r;
      }, {});
    }

    let backgroundColors = groups.map((v, i) => `hsl(${(360 / groups.length) * i}, 90%, 80%)`);
    let borderColors = groups.map((v, i) => `hsl(${(360 / groups.length ) * i}, 90%, 50%)`);
    data = [...Object.keys(data)].map((k, i) => ({ label: k, backgroundColor: backgroundColors[i], borderWidth: 1, borderColor: borderColors[i], data: data[k].map(c => c.amount)}));
    const myChart = new Chart(this.chartTarget, {
      type: 'bar',
      data: {
        labels: xValue,
          datasets: data,
          backgroundColor: backgroundColors,
          borderColor: borderColors
      },
      options: {
          scales: {
              y: {
                  beginAtZero: true
              }
          },
          barValueSpacing: 20
      }
    });
  }
}
