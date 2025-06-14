import React, { useState, useEffect } from 'react';
import { useNavigate } from "react-router-dom";

import { FaBars, FaTimes, FaPlus, FaEdit, FaTrash, FaSignOutAlt } from 'react-icons/fa';
import { MdFlight, MdPeople, MdBusiness, MdEvent, MdFeedback, 
         MdAttachMoney, MdInventory, MdSchedule, MdMessage, MdWarning } from 'react-icons/md';
import "./AdminHome.css";

const AdminHome = () => {
  const [activeTab, setActiveTab] = useState('employees');
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [currentItem, setCurrentItem] = useState(null);
  const [formData, setFormData] = useState({});
  const [sidebarOpen, setSidebarOpen] = useState(false);

    // Icons mapping for each entity
    const entityIcons = {
      employees: <MdPeople />,
      facilities: <MdBusiness />,
      customers: <MdPeople />,
      bookings: <MdEvent />,
      feedback: <MdFeedback />,
      revenue: <MdAttachMoney />,
      inventory: <MdInventory />,
      flights: <MdFlight />,
      staff_schedule: <MdSchedule />,
      communication: <MdMessage />,
      incidents: <MdWarning />
    };

  // Define the structure of each entity based on your DDL
  const entitySchemas = {
    employees: {
      fields: [
        { name: 'Employee_Id', type: 'number', editable: false },
        { name: 'Name', type: 'text', editable: true },
        { name: 'Role', type: 'select', options: ['Manager', 'Staff', 'Technician', 'Cleaner', 'Security', 'Authority'], editable: true },
        { name: 'Shift_Timings', type: 'text', editable: true }
      ],
      endpoint: 'employees'
    },
    facilities: {
      fields: [
        { name: 'Facility_Id', type: 'number', editable: false },
        { name: 'Name', type: 'text', editable: true },
        { name: 'Type', type: 'select', options: ['Gym', 'Lounge', 'Restaurant', 'Shop', 'Other'], editable: true },
        { name: 'Location', type: 'text', editable: true },
        { name: 'Contact_No', type: 'tel', editable: true },
        { name: 'Opening_Hours', type: 'text', editable: true },
        { name: 'Manager_Id', type: 'number', editable: true }
      ],
      endpoint: 'facilities'
    },
    customers: {
      fields: [
        { name: 'Aadhaar_No', type: 'text', editable: false },
        { name: 'Customer_Name', type: 'text', editable: true },
        { name: 'Age', type: 'number', editable: true },
        { name: 'Contact_No', type: 'tel', editable: true }
      ],
      endpoint: 'customers'
    },
    bookings: {
      fields: [
        { name: 'Booking_Id', type: 'number', editable: false },
        { name: 'Facility_Id', type: 'number', editable: true },
        { name: 'Aadhaar_No', type: 'text', editable: true },
        { name: 'Employee_Id', type: 'number', editable: true },
        { name: 'Date_Time', type: 'datetime-local', editable: true },
        { name: 'Payment_Status', type: 'select', options: ['Pending', 'Completed', 'Cancelled'], editable: true }
      ],
      endpoint: 'bookings'
    },
    feedback: {
      fields: [
        { name: 'Feedback_Id', type: 'number', editable: false },
        { name: 'Facility_Id', type: 'number', editable: true },
        { name: 'Aadhaar_No', type: 'text', editable: true },
        { name: 'Manager_Id', type: 'number', editable: true },
        { name: 'Date_Time', type: 'datetime-local', editable: true },
        { name: 'Rating', type: 'number', editable: true },
        { name: 'Comments', type: 'text', editable: true }
      ],
      endpoint: 'feedback'
    },
    revenue: {
      fields: [
        { name: 'Financial_Year', type: 'number', editable: false },
        { name: 'Facility_Id', type: 'number', editable: false },
        { name: 'Monthly_Revenue', type: 'number', editable: true },
        { name: 'Yearly_Revenue', type: 'number', editable: true }
      ],
      endpoint: 'revenue'
    },
    inventory: {
      fields: [
        { name: 'Inventory_Id', type: 'number', editable: false },
        { name: 'Facility_Id', type: 'number', editable: true },
        { name: 'Item_Name', type: 'text', editable: true },
        { name: 'Quantity', type: 'number', editable: true },
        { name: 'Supplier', type: 'text', editable: true }
      ],
      endpoint: 'inventory'
    },
    flights: {
      fields: [
        { name: 'Flight_Id', type: 'number', editable: false },
        { name: 'Flight_Number', type: 'text', editable: true },
        { name: 'Airline', type: 'text', editable: true },
        { name: 'Departure_Time', type: 'datetime-local', editable: true },
        { name: 'Arrival_Time', type: 'datetime-local', editable: true },
        { name: 'Status', type: 'select', options: ['On Time', 'Delayed', 'Cancelled', 'Departed', 'Arrived'], editable: true },
        { name: 'Gate', type: 'text', editable: true },
        { name: 'Terminal', type: 'text', editable: true }
      ],
      endpoint: 'flights'
    },
    staff_schedule: {
      fields: [
        { name: 'Schedule_Id', type: 'number', editable: false },
        { name: 'Employee_Id', type: 'number', editable: true },
        { name: 'Facility_Id', type: 'number', editable: true },
        { name: 'Shift_Date', type: 'date', editable: true },
        { name: 'Shift_Start', type: 'time', editable: true },
        { name: 'Shift_End', type: 'time', editable: true },
        { name: 'Task_Description', type: 'text', editable: true },
        { name: 'Created_At', type: 'datetime-local', editable: false }
      ],
      endpoint: 'staff-schedule'
    },
    communication: {
      fields: [
        { name: 'Message_Id', type: 'number', editable: false },
        { name: 'Sender_Id', type: 'number', editable: true },
        { name: 'Receiver_Id', type: 'number', editable: true },
        { name: 'Message_Type', type: 'select', options: ['Alert', 'Notice', 'Message'], editable: true },
        { name: 'Message', type: 'text', editable: true },
        { name: 'Sent_At', type: 'datetime-local', editable: false }
      ],
      endpoint: 'communication'
    },
    incidents: {
      fields: [
        { name: 'Incident_Id', type: 'number', editable: false },
        { name: 'Reported_By', type: 'number', editable: true },
        { name: 'Facility_Id', type: 'number', editable: true },
        { name: 'Description', type: 'text', editable: true },
        { name: 'Status', type: 'select', options: ['Reported', 'In Progress', 'Resolved'], editable: true },
        { name: 'Reported_At', type: 'datetime-local', editable: false },
        { name: 'Resolved_At', type: 'datetime-local', editable: true }
      ],
      endpoint: 'incidents'
    }
  };

  useEffect(() => {
    fetchData();
  }, [activeTab]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const response = await fetch(`http://localhost:3000/${entitySchemas[activeTab].endpoint}`);
      const result = await response.json();
      setData(result);
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleEdit = (item) => {
    setEditMode(true);
    setCurrentItem(item);
    setFormData(item);
  };

  const handleCreate = () => {
    setEditMode(true);
    setCurrentItem(null);
    // Initialize form with empty values based on schema
    const initialFormData = {};
    entitySchemas[activeTab].fields.forEach(field => {
      if (field.editable) {
        initialFormData[field.name] = '';
      }
    });
    setFormData(initialFormData);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const endpoint = entitySchemas[activeTab].endpoint;
      let url = `http://localhost:3000/${endpoint}`;
      let method = 'POST';
      
      if (currentItem) {
        // For update, we need to identify the primary key(s)
        const primaryKeys = entitySchemas[activeTab].fields.filter(f => !f.editable);
        if (primaryKeys.length === 1) {
          url += `/${currentItem[primaryKeys[0].name]}`;
          method = 'PUT';
        } else {
          // Handle composite primary keys if needed
          console.error('Composite primary keys not fully implemented');
          return;
        }
      }

      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        fetchData();
        setEditMode(false);
      } else {
        console.error('Error saving data');
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  const handleDelete = async (item) => {
    if (window.confirm('Are you sure you want to delete this item?')) {
      try {
        const primaryKeys = entitySchemas[activeTab].fields.filter(f => !f.editable);
        if (primaryKeys.length === 1) {
          const endpoint = entitySchemas[activeTab].endpoint;
          const response = await fetch(`http://localhost:3000/${endpoint}/${item[primaryKeys[0].name]}`, {
            method: 'DELETE',
          });

          if (response.ok) {
            fetchData();
          } else {
            console.error('Error deleting data');
          }
        }
      } catch (error) {
        console.error('Error:', error);
      }
    }
  };

  const toggleSidebar = () => {
    setSidebarOpen(!sidebarOpen);
  };

  const renderForm = () => {
    const schema = entitySchemas[activeTab];
    return (
      <div className="form-modal">
        <div className="form-content">
          <h2>{currentItem ? 'Edit' : 'Create'} {activeTab.replace('_', ' ')}</h2>
          <form onSubmit={handleSubmit}>
            {schema.fields.map((field) => {
              if (!field.editable && !currentItem) return null;
              
              if (field.type === 'select') {
                return (
                  <div key={field.name} className="form-group">
                    <label>{field.name.replace('_', ' ')}</label>
                    <select
                      name={field.name}
                      value={formData[field.name] || ''}
                      onChange={handleInputChange}
                      disabled={!field.editable}
                    >
                      {field.options.map(option => (
                        <option key={option} value={option}>{option}</option>
                      ))}
                    </select>
                  </div>
                );
              } else {
                return (
                  <div key={field.name} className="form-group">
                    <label>{field.name.replace('_', ' ')}</label>
                    <input
                      type={field.type}
                      name={field.name}
                      value={formData[field.name] || ''}
                      onChange={handleInputChange}
                      disabled={!field.editable}
                    />
                  </div>
                );
              }
            })}
            <div className="form-actions">
              <button type="submit" className="btn-primary">
                Save
              </button>
              <button 
                type="button" 
                onClick={() => setEditMode(false)}
                className="btn-secondary"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      </div>
    );
  };

    const navigate = useNavigate();
  
  const renderTable = () => {
    if (loading) return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
        <p>Loading data...</p>
      </div>
    );
    
    if (data.length === 0) return (
      <div className="empty-state">
        <p>No {activeTab.replace('_', ' ')} data available</p>
        <button onClick={handleCreate} className="btn-primary">
          <FaPlus /> Create New
        </button>
      </div>
    );

    const schema = entitySchemas[activeTab];
    return (
      <div className="table-container">
        <div className="table-header">
          <h3>{activeTab.replace('_', ' ').toUpperCase()} MANAGEMENT</h3>
          <button onClick={handleCreate} className="btn-primary">
            <FaPlus /> Create New
          </button>
        </div>
        
        <div className="table-responsive">
          <table>
            <thead>
              <tr>
                {schema.fields.map(field => (
                  <th key={field.name}>{field.name.replace('_', ' ')}</th>
                ))}
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {data.map((item, index) => (
                <tr key={index}>
                  {schema.fields.map(field => (
                    <td key={`${index}-${field.name}`}>
                      {field.type === 'datetime-local' || field.type === 'date' || field.type === 'time'
                        ? new Date(item[field.name]).toLocaleString()
                        : item[field.name]}
                    </td>
                  ))}
                  <td className="actions-cell">
                    <button 
                      onClick={() => handleEdit(item)} 
                      className="btn-edit"
                    >
                      <FaEdit />
                    </button>
                    <button 
                      onClick={() => handleDelete(item)} 
                      className="btn-delete"
                    >
                      <FaTrash />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    );
  };

  return (
    <div className={`admin-dashboard ${sidebarOpen ? 'sidebar-open' : ''}`}>
      {/* Mobile Header - Fixed position */}
      <div className="mobile-header">
        <button className="menu-toggle" onClick={toggleSidebar}>
          {sidebarOpen ? <FaTimes size={20} /> : <FaBars size={20} />}
        </button>
        <h1 className="mobile-title">
          {activeTab.charAt(0).toUpperCase() + activeTab.slice(1).replace('_', ' ')}
        </h1>
      </div>
  
{/* Sidebar */}
<div className="sidebar">
      <div className="sidebar-header">
        <h2>Airport Admin</h2>
        <button 
          className="sidebar-close" 
          onClick={toggleSidebar}
          style={{ display: 'none' }}
        >
          <FaTimes />
        </button>
      </div>
      
      <div className="sidebar-content">
        <ul>
          {Object.keys(entitySchemas).map(entity => (
            <li
              key={entity}
              className={activeTab === entity ? 'active' : ''}
              onClick={() => {
                setActiveTab(entity);
                setSidebarOpen(false);
              }}
            >
              <span className="entity-icon">{entityIcons[entity]}</span>
              <span className="entity-name">
                {entity.charAt(0).toUpperCase() + entity.slice(1).replace('_', ' ')}
              </span>
            </li>
          ))}
        </ul>

        {/* Add this section for profile and logout */}
        <div className="sidebar-footer">
          <div className="profile-info">
            <div className="profile-icon">
              <MdPeople size={24} />
            </div>
            <div className="profile-details">
              <span className="profile-name">Admin User</span>
              <span className="profile-role">Administrator</span>
            </div>
          </div>
          <button className="logout-btn" onClick={() => navigate("/LoginSignUp", { replace: true}) }>
            <FaSignOutAlt size={18} />
            <span>Logout</span>
          </button>
        </div>
      </div>
    </div>

  
      {/* Main Content */}
      <div className="main-content">
        {renderTable()}
      </div>
  
      {/* Form Modal */}
      {editMode && renderForm()}
    </div>
  );
  
};



export default AdminHome;