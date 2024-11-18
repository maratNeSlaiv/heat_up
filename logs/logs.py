import logging
import os
# from datetime import datetime
ABSOLUTE_PATH = os.getenv('ABSOLUTE_PATH')
def setup_logging():
    logging.basicConfig(
        filename=os.path.join(ABSOLUTE_PATH,'/logs/logs_oct_2024.txt'),
        filemode='a',                 
        format='%(asctime)s - %(levelname)s - %(message)s',
        level=logging.INFO
    )