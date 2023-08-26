class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan) #require(:モデル名)とする
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x| #xの数値は0始まる
      today_plans = []
      plans.each do |plan| #planの数だけ処理を行う（つまり7回）。1日に1つの配列todays_planを作成し、planの値を格納
        today_plans.push(plan.plan) if plan.date == @todays_date + x #todayから数えた日付とplanの日付が一致したときにplanの値を取得し、配列todays_planに追加
      end
      
      wday_num = (@todays_date + x).wday
      if wday_num > 7
        wday_num = wday_num - 7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[wday_num] }
      @week_days.push(days)
    end
  end
end

#それぞれの変数の役割
#@week_days → 配列 1週間分の月・日とそれぞれの日のplan情報を持っている
#@todays_date → 今日の日付を格納するための配列
#plans → 配列 今日を合わせて先7日のPlanレコードを格納
#today_plans → 配列 1日に1つ作成。planカラムの情報を格納



