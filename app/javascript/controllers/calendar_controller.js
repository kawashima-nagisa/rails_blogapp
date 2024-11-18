// app/javascript/controllers/calendar_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["canvas"];

  connect() {
    const ctx = this.canvasTarget.getContext("2d");

    // HTMLからデータを取得 (Stimulusのdata-*属性)
    const chartData = JSON.parse(this.canvasTarget.dataset.chartData);
    console.log(chartData);
    // Canvasのサイズを指定（幅と高さを調整）

    // Matrixチャートの初期化
    new Chart(ctx, {
      type: "matrix",
      data: {
        datasets: [
          {
            label: "記事の投稿数と更新回数の合計",
            data: chartData,
            backgroundColor(ctx) {
              //そのマス目の投稿数を取得
              const value = ctx.dataset.data[ctx.dataIndex].v;
              return value > 10
                ? "#1e6823" // 投稿数が多いほど濃い緑に
                : value > 5
                  ? "#44a340"
                  : value > 2
                    ? "#8cc665"
                    : value > 0
                      ? "#d6e685"
                      : "#eeeeee";
            },
            // マス目の幅と高さをCanvasサイズに応じて動的に設定
            width: 12,
            height: 12,
            borderWidth: 1,
            borderColor: "rgba(0,0,0,0.1)",
          },
        ],
      },
      options: {
        responsive: false, // 自動リサイズを無効化
        scales: {
          x: {
            type: "time",
            position: "top",
            time: {
              unit: "month", // X軸を月単位に設定し、月ラベルが表示されるようにする
              round: "month",
              tooltipFormat: "MMM", // ツールチップに「月」を表示
              displayFormats: {
                month: "MMM", // "Jan", "Feb"のように月の略称で表示
              },
            },
            offset: true,
            grid: {
              display: false, // X軸のグリッドを非表示
            },
            ticks: {
              maxRotation: 0,
              autoSkip: false, // ラベルをスキップせずに月ごとに表示
              font: {
                size: 10,
              },
            },
            min: new Date(new Date().getFullYear(), 0, 1).getTime(), // 年の最初の日
            max: new Date(new Date().getFullYear(), 11, 31).getTime(), // 年の最後の日
          },
          y: {
            type: "category",
            labels: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], // 曜日を全て表示
            offset: true,
            grid: {
              display: false, // Y軸のグリッドを非表示
            },
            reverse: false, // 曜日が上から順に並ぶように反転
          },
        },
        plugins: {
          legend: {
            display: false, // 上部の凡例を非表示
          },
          tooltip: {
            callbacks: {
              title: () => "",
              label: (context) =>
                `記事の投稿数と更新回数の合計: ${context.raw.v}`, // ツールチップに投稿数を表示
            },
          },
        },
      },
    });
  }
}
