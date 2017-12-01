require 'rails_helper'

RSpec.describe UpdateTask, type: :service do
  describe '#call' do
    let(:project) { FactoryGirl.create(:project) }
    let(:tasks) { FactoryGirl.create_list(:task, 4, project_id: project.id) }
    let(:params) { double('params') }

    before do
      allow(params)
        .to receive_message_chain(:require, :permit)
        .and_return({})
    end

    describe 'change order of tasks' do
      context 'move up ' do
        before do
          allow(params).to receive(:[]).and_return('up')
        end

        it 'broadcast :ok' do
          expect(UpdateTask.call(tasks.last, params))
            .to broadcast(:ok)
        end

        it 'change order up' do
          last_task = tasks.last
          expect { UpdateTask.call(last_task, params) }
            .to change(last_task, :position)
            .by_at_least(-1)
        end

        it 'move down broadcast :ok' do
          allow(params).to receive(:[]).and_return('down')
          expect(UpdateTask.call(tasks.first, params))
            .to broadcast(:ok)
        end

        it 'change order down' do
          allow(params).to receive(:[]).and_return('down')
          first_task = tasks.first
          expect { UpdateTask.call(first_task, params) }
            .to change(first_task, :position)
            .by_at_least(1)
        end
      end

      it 'broadcast :invalid when task is last' do
        allow(params).to receive(:[]).and_return('down')
        expect(UpdateTask.call(tasks.last, params))
          .to broadcast(:invalid)
      end

      it 'broadcast :invalid when task is first' do
        allow(params).to receive(:[]).and_return('up')
        expect(UpdateTask.call(tasks.first, params))
          .to broadcast(:invalid)
      end
    end

    describe 'update name of task' do
      before do
        allow(params)
          .to receive_message_chain(:require, :permit)
          .and_return(name: 'new name')
        allow_any_instance_of(UpdateTask)
          .to receive(:reorder)
          .and_return(true)
        allow(params).to receive(:[])
      end

      it 'save new name' do
        task = tasks.first
        expect { UpdateTask.call(task, params) }
          .to change(task, :name)
          .to(/new name/)
      end
    end
  end
end
