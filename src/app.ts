import express from 'express';
import cors from 'cors';
import  routes  from './infraestructure/router';
import { PORT } from './config'

const app = express();

app.use(cors({
    origin: "*",
    methods: ["GET","POST","OPTIONS"]
}))
app.use(express.json())
app.use("/", routes)
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`)
})