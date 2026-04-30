# Stage 1: Dependencies
FROM node:22-alpine AS deps 
# All following commands run inside /app folder
WORKDIR /app
# Copy ONLY dependency files first → Docker can cache this layer
COPY package.json package-lock.json ./
#clean install (faster + reproducible, perfect for Docker)
RUN npm install

# Stage 2: Builder
FROM deps AS builder 
WORKDIR /app
COPY . .
RUN npm run build

# Stage 3: Production Runner
FROM deps AS runner
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/public /app/sid/public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/.next/static ./apps/.next/static
COPY --from=builder /app/package.json ./package.json
EXPOSE 5000

# Force Next.js to start on 5000
CMD ["npm", "run", "start", "--", "-p", "5000"]

# docker build . -f Dockerfile -t ssr_ssg_images
# docker run --name ssr_container -p 8000:3000 -p 8001:3001 -it --rm ssr_ssg_images
# docker run -it --rm --name ssr_container -p 5000:5000 -e WATCHPACK_POLLING=true -v "${PWD}:/app" -v /app/node_modules -v /app/.next ssr_ssg_images
# docker exec -it ssr_container /bin/bash

