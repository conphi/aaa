# -*- coding: utf-8 -*-
import scrapy
import re
#import csv

class MmSpider(scrapy.Spider):
    name = 'mm'
    allowed_domains = ['amazon.cn']
    start_urls = ['https://www.amazon.cn/gp/bestsellers/books/659034051',
    'https://www.amazon.cn/gp/bestsellers/books/659034051',
    'https://www.amazon.cn/gp/bestsellers/books/659034051',
    'https://www.amazon.cn/gp/bestsellers/books/659034051',
    'https://www.amazon.cn/gp/bestsellers/books/659034051']
    custom_settings = {
        # 'DOWNLOAD_DELAY' : 3 ,
        'DEFAULT_REQUEST_HEADERS' : { 'Accept' : 'text/html,application/xhtml+xm…plication/xml;q=0.9,*/*;q=0.8',
                                      'Accept-Encoding' :	'gzip, deflate, br',
                                      'Accept-Language' :	'en-US,en;q=0.5' ,
                                      'Cache-Control' : 'max-age=0',
                                      'Connection' : 'keep-alive',
                                      'User-Agent' : 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:59.0) Gecko/20100101 Firefox/59.0',
        },
        'FEED_EXPORT_FIELDS' : ['isbn', 'title', 'author', 'price', 'publisher', 'pub_date', 'page_num', 'page_size', 'content']
        # 'FEED_EXPORTERS' : {'headless': 'test.exporters.HeadlessCsvItemExporter'}
        # 'FEED_EXPORTERS' : {'csv': 'test.exporters.HeadlessCsvItemExporter'}
    }

    # 解析某个二级图书链接的100本书的链接
    def parse(self, response):
        urls = response.xpath("//div[@class='a-fixed-left-grid-col a-col-right']/a[@class='a-link-normal']/@href").extract()
        for url in urls:
            url = "https://www.amazon.cn" + url
            yield scrapy.Request( url = url, callback = self.parse_details)
            
        next_page = response.xpath("//a[@page='2']/@href").extract()[0]
        yield response.follow(next_page, self.parse)
        next_page = response.xpath("//a[@page='3']/@href").extract()[0]
        yield response.follow(next_page, self.parse)
        next_page = response.xpath("//a[@page='4']/@href").extract()[0]
        yield response.follow(next_page, self.parse)
        next_page = response.xpath("//a[@page='5']/@href").extract()[0]
        yield response.follow(next_page, self.parse)


    # 提取一本书的某些字读的数据
    def parse_details(self, response):
        
        #测试
        if 'Kindle' in response.css('title').extract_first():
            if '精装' in response.xpath('//div[@id="tmmSwatches"]/ul/li/span/span/span/a/span/text()').extract():
                url = "https://www.amazon.cn" + response.xpath('//div[@id="tmmSwatches"]/ul/li/span/span/span/a/span[contains(text(),"精装")]/../@href').extract_first()
                yield scrapy.Request( url = url, callback = self.parse_details)
                
            elif '平装' in response.xpath('//div[@id="tmmSwatches"]/ul/li/span/span/span/a/span/text()').extract():
                url = "https://www.amazon.cn" + response.xpath('//div[@id="tmmSwatches"]/ul/li/span/span/span/a/span[contains(text(),"平装")]/../@href').extract_first()
                yield scrapy.Request( url = url, callback = self.parse_details)
            else:
                print('May only Kindle version')
                # with open('mm.csv', 'a') as csvfile:
                #     writer.writerow({'url': response.url})
                #print(response.url)
            
        else:
        
            yield {
                
                'isbn' : re.findall('\d{13}',response.xpath('//div[@id="detail_bullets_id"]//ul/li/b[contains(text(),"ISBN:")]/../text()').extract_first())[0],
                'title' : response.css('#productTitle::text').extract_first(),
                'author' : ''.join(response.xpath("//div[@id='bylineInfo']").xpath('string(.)').extract_first().split()),
                'price' : response.xpath("//div[@id='buyBoxInner']/ul/li/span/span/text()").extract()[1],
                'publisher' : response.xpath('//div[@id="detail_bullets_id"]//ul/li/b[contains(text(),"出版社:")]/../text()').extract_first().split(';')[0].strip(),
                'pub_date' :  response.xpath('//div[@id="detail_bullets_id"]//ul/li/b[contains(text(),"出版社:")]/../text()').extract_first().split(';')[1].strip(),
                'page_num' : response.xpath('//div[@id="detail_bullets_id"]//ul/li[contains(text(),"页")]/text()').extract_first().strip(),
                'page_size' : response.xpath('//div[@id="detail_bullets_id"]//ul/li/b[contains(text(),"开本")]/../text()').extract_first().strip(),
                'content' : ''.join(response.css('noscript>div').xpath('string(.)').extract_first().split())
            }
