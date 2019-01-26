import Chart from "chart.js"; // grabs standalone

const ctx = document.getElementById("myChart").getContext("2d");
let startChart = () => {
  new Chart(ctx, {
    // The type of chart we want to create
    type: "pie",

    // The data for our dataset
    data: {
      labels: window.columns,
      datasets: [
        {
          label: "My First dataset",
          borderColor: [
            "rgba(255, 99, 132, 0.2)",
            "rgba(54, 162, 235, 0.2)",
            "rgba(255, 206, 86, 0.2)",
            "rgba(75, 192, 192, 0.2)",
            "rgba(153, 102, 255, 0.2)",
            "rgba(255, 159, 64, 0.2)"
          ],
          backgroundColor: [
            "rgba(255, 99, 132, 0.2)",
            "rgba(54, 162, 235, 0.2)",
            "rgba(255, 206, 86, 0.2)",
            "rgba(75, 192, 192, 0.2)",
            "rgba(153, 102, 255, 0.2)",
            "rgba(255, 159, 64, 0.2)"
          ],
          data: window.data
        }
      ]
    },

    // Configuration options go here
    options: {}
  });
};

export default startChart;
