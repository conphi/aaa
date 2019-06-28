require 'open-uri'
require 'nokogiri'
require 'net/http'

# url = "https://getyarn.io/yarn-find?text=she%27s" + "&p=0"
# url = "https://getyarn.io/yarn-find?text=euphoria"
base_url = "https://getyarn.io/yarn-find?text=astound"

$i = 0
$page_index = 0

loop do

    url = base_url + "&p=#{$page_index}"
    doc = Nokogiri::HTML(open(url))
    clip_num = doc.search('div.clip-wrap').count
    
    j = 0
    
    while j < clip_num  do
      title = doc.search('div.clip-wrap')[j].search('a').search('div.transcript').text
      path =  doc.search('div.clip-wrap')[j].search('a')[1][:href].split('/')[-1]
    
    # 去掉字符串的引号 title.gsub! /"/, ''
      title.gsub!(/"/,'')
      title.strip!
    
      video_url = "https://y.yarn.co/" + path + ".mp4"
      
      j +=1
      $i=$i.to_i
      $i +=1
      
      if $i <10
        $i = "00#{$i}"
      elsif $i<100
        $i = "0#{$i}"
      end
      
      
      %x[wget -c "#{video_url}" -O "#{$i}".mp4]
    
      
      duration = %x[ffmpeg -i "#{$i}.mp4" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//]
      
      puts duration
      
      File.open("#{$i}.srt", "w") do |f|
        f.write "1\n"
        f.write "00:00:00,0 --> "
        f.write duration.sub(".", ",")
        f.write "#{title}"
      end
    
    
      %x[ffmpeg -i "#{$i}".mp4 -vf subtitles="#{$i}".srt "#{$i}"_srt.mp4]
    
    # %x[rm -rf "#{title}.mp4" "#{title}.srt"]
      
      system("sleep 5")
    end
    
    puts "===================================================#{$i}==========================================================="
    $page_index +=1
    # break if clip_num < 28
    # break if clip_num < 28 || $page_index >34
    break if clip_num < 28 || $page_index > 14
    
end


system("mkdir srt_mp4")
system("mv *srt.mp4 ./srt_mp4")

system("mkdir mp4")
system("mv *.mp4 ./mp4")

%x[rm -rf *.srt]
