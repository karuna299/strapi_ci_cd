# ---------- BUILD STAGE ----------
FROM node:20-slim AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Remove dev dependencies to reduce size
RUN npm prune --production

# ---------- RUN STAGE ----------
FROM node:20-slim

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 1337
CMD ["npm", "run", "start"]