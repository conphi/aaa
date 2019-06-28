import requests
import json

urls = ['https://kuaiyinshi.com/api/hot/videos/?source=dou-yin&page=1&st=week',
       'https://kuaiyinshi.com/api/hot/videos/?source=dou-yin&page=2&st=week',
       'https://kuaiyinshi.com/api/hot/videos/?source=dou-yin&page=3&st=week',
       'https://kuaiyinshi.com/api/hot/videos/?source=dou-yin&page=4&st=week',
       'https://kuaiyinshi.com/api/hot/videos/?source=dou-yin&page=5&st=week'
]
headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
for url in urls:
    r = requests.get(url, headers=headers)
    r_js = r.json()
    for i in range(20):
        title = r_js['data'][i]['desc']
    
        # img_name = title + '.jpg'
        # img_link = 'http:' + r_js['data'][i]['video_img']
        # res_img = requests.get(img_link, headers=headers)
        # with open(img_name, "wb") as f:
        #     f.write(res_img.content)
        
        video_name = title + '.mp4'
        video_link = 'https:' + r_js['data'][i]['video_url']
        res_video = requests.get(video_link, allow_redirects = True, headers=headers)
        with open(video_name, "wb") as f:
            f.write(res_video.content)
