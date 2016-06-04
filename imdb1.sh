#!/bin/bash

find_movies_id() {
  all_ids=$(curl -s http://www.imdb.com/find\?ref_\=nv_sr_fn\&q\=$1\&s\=all \
    | grep -E -0 '/tt\w+' -o)
  movie=${all_ids:1:9}
  echo $movie
}

main() {
  for file in $1/*
  do
    full_name=${file##*/}   
    f_name=$(echo ${full_name//./+})
    f_name=$(echo ${f_name//_/+})
    f_name=$(echo ${f_name// /+})
    movie_id=$(find_movies_id $f_name)
    all_reviews=$(curl -s http://www.imdb.com/title/$movie_id/ \
      | grep "based on" \
      | grep "user rating" \
      | grep "[0-9]\+\.[0-9]\+" -o)
    f_reviews=${all_reviews:0:3}
    f_name=$(echo ${f_name//+/" "})
    echo $f_reviews $f_name
  done | sort -k1 -rn
}

main "$@"
