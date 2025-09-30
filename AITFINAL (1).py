#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
df = pd.read_csv('C:/Users/brown/Desktop/HW3/Jobs_NYC_Postings.csv')
print(df.head())
print(df.info())


# In[2]:


missing_values = df.isnull().sum()
print(missing_values)


# In[7]:


# To drop rows with missing values
df = df.dropna()
print(df.duplicated().sum())
df = df.drop_duplicates()
print(df)


# In[15]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
df = pd.read_csv('C:/Users/brown/Desktop/HW3/Jobs_NYC_Postings.csv')
df['Posting Date'] = pd.to_datetime(df['Posting Date'])
df['Year'] = df['Posting Date'].dt.year
time_series_data = df.groupby(['Year', 'Full-Time/Part-Time indicator']).size().unstack(fill_value=0)
sns.lineplot(data=time_series_data)
plt.title('Demand Over Time for Full-time vs Part-time Jobs')
plt.ylabel('Number of Job Postings')
plt.xlabel('Year')
plt.show()


# In[14]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
nycjobs_data = pd.read_csv('C:/Users/brown/Desktop/HW3/Jobs_NYC_Postings.csv')
agency_counts = nycjobs_data['Agency'].value_counts().reset_index()
agency_counts.columns = ['Agency', 'Count']
top_agencies = agency_counts.head(10)
sns.barplot(data=top_agencies, y='Agency', x='Count', palette='viridis')
plt.title('Top 10 NYC Agencies by Number of Job Postings')
plt.xlabel('Number of Job Postings')
plt.ylabel('Agency')
plt.show()

