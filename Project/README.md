# Title: Conflict of Interest in Financial System and Proposed Solution

What is the conflict? Why does it arrive? How is it incentivized?

United States has a nominal GDP (can also be measured by purchasing power parity, PPP) of [$20 trillion dollars](https://www.bea.gov/news/2019/gross-domestic-product-4th-quarter-and-annual-2018-third-estimate-corporate-profits-4th) while BlackRock (the king of 401k plan provider) holds about [$6 trillion AUM](https://www.marketwatch.com/story/blackrocks-assets-fall-below-6-trillion-mark-2019-01-16) of which [$4 trillion](http://ir.blackrock.com/Cache/1001247206.PDF?O=PDF&T=&Y=&D=&FID=1001247206&iid=4048287) is in equity market, $1 trillion in fixed income, and the rest in derivatives. On top of these numbers, we also know that United States has a population of [320 million people](https://www.census.gov/popclock/) with an average salary of [$56k](https://datausa.io/profile/geo/united-states/) which sum to total of $17.9 trillion dollars (the math seems right). An average American deposit to their savings account of about [7% annually](https://smartasset.com/retirement/average-401k-balance-by-age) which approximates to $1.25 trillion dollars. 

The above figures are simply saying every year we got over $1 trillion money inflow/outflow that we are working with. This is when we have all the giants come in to play around with the market. In my book, top tier ground will have players which composed of the Government and the people. Tier two we can talk about people who directly move money through 401k type of channel which are companies like Vanguard, BlackRock, State Street or individuals such as Warren Buffett, Ray Dalio, Carl Iahn, (of course Gates and Bezos are included but they have real business that they are working with), etc..

# Financial Institutions for Savings Plan

For example, BlackRock does ...

# Proposed Solution

Goal: by carefully investigating clients' personal needs and risk profile, we come up with a solution. 

- Demo for [Retirement Simulation](https://y-yin.shinyapps.io/RETIREMENT-SIMULATION/);

I proposed an algorithm derived from a formula. 

- Theoretical Model [here](https://yiqiaoyin.files.wordpress.com/2018/12/rubust-portfolio-by-influence-measure-yiqiao-yin-2018.pdf);

- Application [here](https://y-yin.shinyapps.io/CENTRAL-INTELLIGENCE-PLATFORM/)

Besides timing, there is a list of building blocks to construct an AI to perform well in stock markets which is briefly discussed in the next section.

## Journey

First, I started by looking at correlation. This links to running regression and I have conducted experiment to learn that myself when I was a freshman. What is the linear relationship between market return and a stock return? How about fundamental values? 
- Paper is [How to Understand Future Returns of a Security](https://yiqiaoyin.files.wordpress.com/2016/08/how-to-understand-future-returns-of-a-securityef80a5-revised-2014.pdf).

Next, I started to size up. A data composed of stock-to-market comparison seemed too easy, so I started looking at cross-sectional finance data. The common data set that is used for PhD students in finance is CRSP stock universe. This is where I started to work with large-scale matrices that are 2GB in size and when I learned to work with different forms of data frames. It started to turn into tedious data clean-up work. However, the results are interesting. 
- I wrote [Cross-section Study on Stock Returns](https://yiqiaoyin.files.wordpress.com/2016/08/cross-section-study-on-stock-returns-to-future-expectation-theorem.pdf); and 
- Another similar project that examines stock market through market value balance sheet, click [here](https://yiqiaoyin.files.wordpress.com/2016/08/alternative-empirical-study-on-market-value-balance-sheet.pdf) if interested.

After looking at tons of stock returns data set, I got bored at conventional way of analyzing stock market. I invented this term "greed" so that I can turn this into a supervised model for myself to study. This is not publishable idea, but quite interesting to me. 
- Paper is [here](https://yiqiaoyin.files.wordpress.com/2016/05/empirical-study-on-greed.pdf). 

In 2016 I took a little digression to study macroeconomics. I did a project on contact rate in game theory. The paper was too hard, but the coding part is easy. I got stuck on dynamic model in macro material and it took me 3 months to figure this out. It leads to nowhere, but I am grateful to the professor who instructed me and him spending time with me on this project. 
- Trade Dynamics with Endogenous Contact Rate is [here](https://yiqiaoyin.files.wordpress.com/2016/10/trade-dynamics-with-endogenous-contact-rate.pdf). 

After trading floor, I took a little bit of time and summarizing my experiences on the trading floor and they become the following series of papers:
- [Buy Signal from Limit Theorem](https://yiqiaoyin.files.wordpress.com/2018/05/buy-signal-from-limit-theorem.pdf)
- [Time Series Analysis on Stock Returns](https://yiqiaoyin.files.wordpress.com/2017/05/time-series-analysis-on-stock-returns.pdf)
- [Martingale to Optimal Trading](https://yiqiaoyin.files.wordpress.com/2016/10/martingale-to-optimal-trading.pdf)
- [Anomaly Correction by Trading Frequency](https://yiqiaoyin.files.wordpress.com/2016/09/anomaly-correction-by-trading-frequency.pdf)
- [Absolute Alpha with Moving Averages: A Consistent Trading Strategy](https://yiqiaoyin.files.wordpress.com/2016/05/absolute-alpha-with-moving-averages.pdf)
- [Absolute Alpha with Limited Leverage](https://yiqiaoyin.files.wordpress.com/2016/05/absolute-alpha-with-limited-leverage.pdf)
- [Absolute Alpha by Beta Manipulation](https://yiqiaoyin.files.wordpress.com/2016/05/absolute-alpha-by-beta-manipulation.pdf)
and this when I started to build up intra-discplinary experience across the fields of (1) trading, (2) probability theory, (3) accounting, and (4) game theory. Most of what I am right now depend on these past couple of papers.

Interesting phenomenon (and you probably saw it too) was that I did not have any machine learning technique discussed yet. However, the few papers above gave me a unique view so that I can create any stock data however I want. This is when machine learning comes in, which leads to this paper.
- [Robust Portfolio by Influence Measure with presentation](https://yiqiaoyin.files.wordpress.com/2018/12/rubust-portfolio-by-influence-measure-yiqiao-yin-2018.pdf)
- A small project that comes along this paper is finished as [an Applied Data Science project](https://github.com/yiqiao-yin/Fall2018-Advanced-Data-Science-Final-Project)

I am now equipped with two unique skills: (1) I can use probability theory to manipulate and invent any stock data helpful for me; and (2) I can invent a machine learning algorithm that solves that problem. All of these ideas are updated frequently [here](https://yinscapital.com/private-collection/).


# Conclusion

Where do you stand in this societal pyramid? Top of bottom? Are you going to make fortune of yourself and give your kids a better life? If yes, exactly what steps are you taking to achieve that? If you don’t have any clue about how to tackle these problems, you are welcomed to come to me and I can provide this service for free. 
