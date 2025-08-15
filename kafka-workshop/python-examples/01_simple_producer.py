from confluent_kafka import Producer
import json
import time
import os

def main():
    # Use environment variable with fallback to Docker default
    bootstrap_servers = os.getenv('KAFKA_BOOTSTRAP_SERVERS', 'kafka:29092')
    
    producer = Producer({'bootstrap.servers': bootstrap_servers})
    
    print(f"📤 Connecting to Kafka at: {bootstrap_servers}")
    print("📤 Sending 10 simple messages...")
    
    for i in range(10):
        message = {
            'id': i,
            'message': f'Hello Kafka {i}!',
            'timestamp': time.time()
        }
        
        try:
            producer.produce('my-first-topic', json.dumps(message))
            print(f"Sent: {message}")
        except Exception as e:
            print(f"Error sending message {i}: {e}")
            break
            
        time.sleep(1)
    
    # Ensure all messages are delivered
    producer.flush()
    print("✅ All messages sent!")

if __name__ == "__main__":
    main()