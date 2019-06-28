import requests
import re
import csv
import os
import time
from selenium import webdriver
from pyquery import PyQuery as pq
from lxml import etree
from bs4 import BeautifulSoup as bs


chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--headless")
driver = webdriver.Chrome(chrome_options = chrome_options)
driver.implicitly_wait(10) # seconds

def bookcsv(d, csvname):
    tmp = d("#detail_bullets_id ul li")
    title = d("#productTitle").text()
    author = d("#bylineInfo").text()
    price =  d("#buyBoxInner").text().split("￥")[1].strip()
    #price = str(price).split("￥").strip()
    isbn = tmp.filter(lambda i: 'ISBN' in pq(this).text()).text().split(":")[1].strip()
    publish = tmp.filter(lambda i: '出版社' in pq(this).text()).text().split(":")[1].strip()
    publisher = publish.split(';')[0].strip()
    pub_date =  publish.split(';')[1].strip()
    try:
        page_num = tmp.filter(lambda i: '页' in pq(this).text()).text().split(":")[1].strip()
    except:
        page_num = ''
    # page_num = tmp.filter(lambda i: '页' in pq(this).text()).text().split(":")[1].strip()
    page_size = tmp.filter(lambda i: '开本' in pq(this).text()).text().split(":")[1].strip()
    content = d("noscript").text()
    content = re.findall("<div>.*?</div>",content)[0]
    content = pq(content).text()
    with open(csvname,'a', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([isbn, title, author, price, publisher, pub_date, page_num, page_size,content])

def bookself(url,csvname):
    driver.get(url)
    page = driver.page_source
    d = pq(page)
    title = d('title').text()
    tmp = d("#tmmSwatches ul li span span span a")
    zx_text = tmp("span").filter(lambda i: '精装' in pq(this).text()).text()
    pz_text = tmp("span").filter(lambda i: '平装' in pq(this).text()).text()
    
    if "Kindle" in title:
        if zx_text != '':
            print('found it 精装')
            re_test = tmp.filter(lambda i: '精装' in pq(this).text())
            zx_url = 'https://www.amazon.cn' + re.findall(r"/../.*?;", str(re_test))[0]
            driver.get(zx_url)
            page = driver.page_source
            d = pq(page)
            bookcsv(d, csvname)
        elif pz_text != '':
            print('found it 平装')
            re_test = tmp.filter(lambda i: '平装' in pq(this).text())
            px_url = 'https://www.amazon.cn' + re.findall(r"/../.*?;", str(re_test))[0]
            driver.get(px_url)
            page = driver.page_source
            d = pq(page)
            bookcsv(d, csvname)
        else:
            print('only Kindle version')
    else:
        bookcsv(d, csvname)


def top_100(level_two_url_con,csvroute):
    for part_20_url in level_two_url_con:
        r = requests.get(part_20_url)
        soup = bs(r.text,"html.parser")
        #soup = bs(r.text,"lxml")
        book_list = soup.find_all(id='zg')
        for i in range(book_list[0].select('a[href*="/dp/"]').__len__()):
            try:
                book_url = 'https://www.amazon.cn'+ book_list[0].select('a[href*="/dp/"]')[i]["href"]
                book_title = book_list[0].select('a[href*="/dp/"]')[i].img['alt']
                bookself(book_url,csvname)
            except TypeError:
                pass

r = requests.get('https://www.amazon.cn/gp/bestsellers/books')
print(r.status_code)
soup = bs(r.text,"html.parser")

#建立根目录cc（Linux环境）
rootcc = '/home/ubuntu/workspace/cc/'
if not os.path.exists(rootcc):
    os.mkdir(rootcc)

##初始化，获取二级最终页面的分P URL的相对链接的 列表 共5个元素
level_two_url_part =['ref=zg_bs_pg_1?ie=UTF8&pg=1'.replace('1',str(i)) for i in range(1,6)]

#获取一级图书大类的URL列表
level_one_lists = soup.select('#zg_browseRoot ul li a[href]')

for i in level_one_lists:
    if not (i.string == '预售图书' or i.string == '在线试读' or i.string == '期刊杂志' or i.string == '进口原版书'):
        level_one_url = i.attrs['href']
        level_one_name = i.string
        
        #建立根目录下的一级目录
        firdir = rootcc + level_one_name + '/'
        if not os.path.exists(firdir):
            os.mkdir(firdir)
        
        ##获取top100图书二级链接，也是最终book_list的链接
        level_two_lists = bs(requests.get(level_one_url).text,"html.parser").select('#zg_browseRoot ul li a[href]')[1:]
        for j in level_two_lists:
            level_two_url = j.attrs['href'] + '/'
            level_two_name = j.string
            
            #获取二级最终的分P页面 URL 总列表 共5个元素
            level_two_url_con = [level_two_url + level_two_url_part[m] for m in range(5)]
            
            csvname = firdir + level_two_name + '.csv'
            with open(csvname,'a', newline='') as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow(['ISBN', '书名', '作者', '定价', '出版社', '出版时间', '页数', '开本','内容简介'])
            ###收集到每个二级类别的亚马逊图书销售排行榜到 TOP 100 图书。
            top_100(level_two_url_con,level_two_name)




driver.close()
driver.quit()
