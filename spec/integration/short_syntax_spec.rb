require 'spec_helper'

describe 'Short syntax' do
  before(:each) do
    Triggerable::Engine.clear
    TestTask.destroy_all
  end

  it 'is' do
    TestTask.trigger on: :after_update, if: {status: 'solved'} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'in' do
    TestTask.trigger on: :after_update, if: {status: ['solved', 'confirmed']} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')

    task2 = TestTask.create
    expect(TestTask.count).to eq(3)

    task2.update_attributes status: 'confirmed'
    expect(TestTask.count).to eq(4)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'method call' do
    TestTask.trigger on: :after_update, if: :solved? do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'method predicate call' do
    TestTask.trigger on: :after_update, if: { and: [:solved?, :true_method] } do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'method predicate call 2' do
    TestTask.trigger on: :after_update, if: { or: [:solved?, :true_method] } do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'not_solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'passes context to action' do
    TestTask.trigger on: :before_update, if: :solved? do
      self.status = 'confirmed'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(task.status).to eq('confirmed')
  end
end
