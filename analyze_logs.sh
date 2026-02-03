echo "Отчет о логе веб-сервера" >> report.txt
echo "========================" >> report.txt

awk '{counter++} END {printf "Общее количество запросов:%9d\n", counter}' access.log >> report.txt

awk '{ip[$1]++} END {printf "Количество уникальных IP-адресов:%9d\n", length(ip)}' access.log >> report.txt

echo >> report.txt

awk '{
    match($6, /"[A-Z]+/)
    if (RSTART) {
        method = substr($6, RSTART+1, RLENGTH-1)
        count[method]++
    	}
}
END {
    print "Количество запросов по методам:"
    for (m in count)
        printf "%5d %s\n", count[m], m
}' access.log >> report.txt

echo >> report.txt

awk '{
    if (match($0, /"[A-Z]+ \/([^ ]*)/, arr)) {
        url = "/" arr[1]
        count[url]++
    }
}
END {
    max=0
    popular_url=""
    for (url in count) {
        if (count[url] > max) {
            max = count[url]
            popular_url = url
	}
    }
    printf "Самый популярный URL:      %d %s\n", max, popular_url
}' access.log >> report.txt
