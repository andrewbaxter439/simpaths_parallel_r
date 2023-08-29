# Runs 1,000 runs as 50 sequential runs of n=20 with 50 unique starting seeds 
seq 100 100 5000 | parallel java -cp simpaths.jar simpaths.experiment.SimPathsMultiRun -r {} -n 20 -p 150000 -s 2017 -e 2025 -g false -f
#
# Combine csvs to parquet files in 'reform_sens' folder (change to new folder)
Rscript R/combining_arrow_data.R reform_sens

# Tidy output folders, removing empty database folders and redundant input folders (keeps csvs)
rm -r output/2023*/database
rm -r output/2023*/input

# Compress to tar.zip archive using pigzip
tar -cv -I 'pigz --zip' -f /storage/andy/simpaths_outputs/csvs/reform_sens_outputs.tar.zip /storage/andy/simpaths_outputs/output

# Text myself that it's all done
curl "https://api.telegram.org/bot${Notify_bot_key}/sendMessage?text=Done%20copying%20all%20files&chat_id=${telegram_chatid}"
