from confluent_kafka import Consumer, KafkaError
import json
import os

def main():
    bootstrap_servers = os.getenv('KAFKA_BOOTSTRAP_SERVERS', 'kafka:29092')
    
    print("🚀 Starting consumer...")
    print(f"📍 Bootstrap servers: {bootstrap_servers}")
    
    consumer = Consumer({
        'bootstrap.servers': bootstrap_servers,
        'group.id': 'python-consumer-group',
        'auto.offset.reset': 'earliest'
    })
    
    print("✅ Consumer created")
    
    consumer.subscribe(['my-first-topic'])
    print("✅ Subscribed to 'my-first-topic'")
    print("🔍 Starting to poll...")
    
    try:
        message_count = 0
        poll_count = 0
        
        while True:
            poll_count += 1
            print(f"Poll #{poll_count}...")
            
            msg = consumer.poll(2.0)  # 2 second timeout
            
            if msg is None:
                print("   → No message (timeout)")
                continue
                
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    print("   → End of partition")
                    continue
                else:
                    print(f"   → ERROR: {msg.error()}")
                    break
            
            # We got a message!
            message_count += 1
            print(f"   → 📨 MESSAGE #{message_count}")
            print(f"       Topic: {msg.topic()}")
            print(f"       Partition: {msg.partition()}")
            print(f"       Offset: {msg.offset()}")
            print(f"       Value: {msg.value()}")
            
            # Stop after 10 messages for testing
            if message_count >= 10:
                print("✅ Received 10 messages, stopping...")
                break
                
    except KeyboardInterrupt:
        print("\n🛑 Interrupted")
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        consumer.close()
        print("✅ Consumer closed")

if __name__ == "__main__":
    main()