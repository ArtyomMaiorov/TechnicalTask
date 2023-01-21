import requests
from bs4 import BeautifulSoup
import pandas as pd
import urllib3

urllib3.disable_warnings()


class Parser:
    def __init__(self):
        self.overall = []
        self.df = None

    def get_links(self):
        cnt = 0
        links = []
        for i in range(1, 6):
            cnt = cnt + 1
            print(cnt)
            url = f'https://www.goszakup.gov.kz/ru/registry/rqc?count_record=100&page={i}'
            try:
                r = requests.get(url, verify=False)
                soup = BeautifulSoup(r.text, 'html.parser')
                table = soup.find('table')
                tbody = table.find('tbody')
                tr_tags = tbody.find_all('tr')
                for tr in tr_tags:
                    link = tr.find('a')
                    if link:
                        href = link.get('href')
                        print(href)
                        self.get_data(href)
                    else:
                        continue
            except Exception as e:
                print(e)

    def get_data(self, url):
        try:
            td_data = dict()

            r = requests.get(url, verify=False)
            soup = BeautifulSoup(r.text, 'lxml')
            tables = soup.find_all('table', attrs={'class': 'table table-striped'})
            for i in range(len(tables)):
                if i == 3:
                    address = tables[3].find_all('td')[2].text
                    td_data['Полный адрес организации'] = address
                    continue
                table = tables[i]
                rows = table.find_all('tr')
                for row in rows:
                    names = row.find('th')
                    if names:
                        names = row.find('th').text
                    cols = row.find('td')
                    if cols:
                        cols = cols.text
                    td_data[names] = cols
            print(td_data)
            self.get_five_fields(td_data)
        except Exception as e:
            print(e)

    def get_five_fields(self, data_dict):
        organization_name = data_dict['Наименование на рус. языке']
        organization_bin = data_dict['БИН участника']
        head_name = data_dict['ФИО']
        head_iin = data_dict['ИИН']
        organization_address = data_dict['Полный адрес организации']
        self.overall.append([organization_name, organization_bin, head_name, head_iin, organization_address])

    def create_df(self):
        self.df = pd.DataFrame(self.overall, columns=['Наименование организации', 'БИН участника', 'ФИО руководителя',
                                                      'ИИН руководителя',
                                                      'Полный адрес организации'])
        self.df = self.df.drop_duplicates()

    def export_to_excel(self):
        self.df.to_excel("data.xlsx")


parser = Parser()
parser.get_links()
parser.create_df()
parser.export_to_excel()
print(parser.df.to_string())
