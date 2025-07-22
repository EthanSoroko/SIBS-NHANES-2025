## 📊 Datasets

This project uses data from the **2021–2023 NHANES cycle**, which resumed after the COVID-19 fieldwork suspension. The datasets are in `.xpt` (SAS transport) format and were collected using an updated sampling design. For more details on this cycle's methodology, see the [NHANES Plan and Operations Report](https://www.cdc.gov/nchs/nhanes/index.htm).

### Included Files

- **`DEMO_L.xpt`** — *Demographics*  
  Contains demographic characteristics of participants, including:
  - Age, sex, race/Hispanic origin
  - Marital status, military service
  - Household size and composition
  - Education and country of birth
  - Family income-to-poverty ratio
  - Interview/exam status, sampling weights, masked variance units

- **`INQ_L.xpt`** — *Income & Assets*  
  Provides family-level income data, including:
  - Monthly income categories
  - Cash assets
  - Some annual income variables (also found in `DEMO_L`)

- **`RXQ_RX_L.xpt`** — *Prescription Medications*  
  Includes self-reported prescription medication use in the past 30 days:
  - Total number of prescription medications used
  - COVID-19 treatment/prevention medication use (only in year 2 — available via NCHS Research Data Center)

- **`HUQ_L.xpt`** — *Healthcare Access & Utilization*  
  Contains self-reported data on:
  - Place most often visited for care
  - Health insurance coverage
  - Delays in care due to cost
  - Overall health status and hospital utilization

> ℹ️ These files can be opened using SAS, R, or Python with appropriate packages (e.g., `haven` or `pyreadstat`).
