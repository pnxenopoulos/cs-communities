echo "---------- Making necessary directories ----------"
cd prepare-data
mkdir data
cd graphs
mkdir graph_data
cd ..
cd data
echo "---------- Downloading data ----------"
wget https://lfs.aminer.cn/lab-datasets/citation/dblp.v10.zip || curl -O https://lfs.aminer.cn/lab-datasets/citation/dblp.v10.zip
unzip *.zip
cd dblp-ref
mv *.json ..
cd ..
rm -rf *.zip
rm -rf dblp-ref
cd ../..
echo "---------- Create .gitignore ----------"
touch .gitignore
echo 'prepare-data/data/' > .gitignore
echo 'prepare-data/graphs/' >> .gitignore
echo 'web/data/' >> .gitignore
echo "---------- Writing data (can take a while) ----------"
cd prepare-data
Rscript scrape_communities.R
python fuzzy_community_match.py
python process_data.py
Rscript format_data.R
